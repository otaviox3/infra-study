# CI para o lab hello-webapp com GitHub Actions (com cluster Kind)

Autor: **Otávio Azevedo**

Este documento descreve o pipeline de **Integra Integração Contínua (CI)** que configurei para o laboratório `labs/hello-webapp-docker-k8s`, usando **GitHub Actions**, testes automatizados, Docker e um cluster Kubernetes temporário com **Kind**.

O objetivo desse CI é:

- garantir que a aplicação Flask do lab continua funcionando (testes com `pytest`);
- verificar se os manifests Kubernetes estão bem formados (YAML válido);
- garantir que o `Dockerfile` continua buildando;
- **subir um cluster Kubernetes (Kind) dentro do pipeline** e aplicar os manifests nele.

---

## 1. Estrutura do lab

O lab fica em:

```text
labs/hello-webapp-docker-k8s/
  app.py
  requirements.txt
  Dockerfile
  tests/
    test_app.py
  k8s/
    deployment.yaml
    service.yaml
  README.md
```

A aplicação é um serviço Flask com:

- `/` → página inicial simples (retorna HTTP 200).
- `/health` → endpoint de healthcheck (retorna `"OK"` e status 200).

---

## 2. Testes automatizados com pytest

O arquivo de testes (`labs/hello-webapp-docker-k8s/tests/test_app.py`) contém dois testes principais:

```python
import sys
from pathlib import Path

# Garante que a pasta raiz do lab esteja no sys.path
ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from app import app


def test_health_endpoint():
    """Garante que /health responde 200 e 'OK'."""
    client = app.test_client()
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.data.decode() == "OK"


def test_root_endpoint():
    """Garante que / responde 200 (página inicial da app)."""
    client = app.test_client()
    resp = client.get("/")
    assert resp.status_code == 200
```

O que esses testes garantem:

- a rota `/health` sempre responde:
  - status HTTP 200;
  - texto `"OK"`;
- a rota `/` responde HTTP 200;
- se qualquer uma dessas rotas quebrar no futuro, o CI falha.

---

## 3. Quando o workflow roda

O workflow está em:

```text
.github/workflows/ci-hello-webapp.yml
```

E é disparado quando:

```yaml
on:
  push:
    paths:
      - "labs/hello-webapp-docker-k8s/**"
      - ".github/workflows/ci-hello-webapp.yml"
  pull_request:
    paths:
      - "labs/hello-webapp-docker-k8s/**"
```

Ou seja:

- roda em qualquer `push` que altere arquivos dentro de `labs/hello-webapp-docker-k8s/**` ou o próprio workflow;
- roda em qualquer `pull_request` que mexa nesse lab.

Alterações em outras partes do repositório **não disparam** esse CI, evitando rodar pipeline sem necessidade.

---

## 4. Job 1 – `test-and-build`

O primeiro job é responsável por:

- preparar o ambiente de Python;
- rodar os testes automatizados;
- validar a sintaxe dos manifests Kubernetes (YAML);
- buildar a imagem Docker da aplicação.

Trecho principal:

```yaml
jobs:
  test-and-build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout do código
        uses: actions/checkout@v4

      - name: Configurar Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Instalar dependências
        run: |
          cd labs/hello-webapp-docker-k8s
          python -m pip install --upgrade pip
          pip install -r requirements.txt
          pip install pytest pyyaml

      - name: Rodar testes
        run: |
          cd labs/hello-webapp-docker-k8s
          pytest

      - name: Validar sintaxe YAML dos manifests Kubernetes
        run: |
          cd labs/hello-webapp-docker-k8s
          python - << 'EOF'
          import glob, yaml, sys

          erros = False
          for path in glob.glob("k8s/*.yaml"):
              print(f"Validando {path}...")
              try:
                  with open(path, "r", encoding="utf-8") as f:
                      list(yaml.safe_load_all(f))
                  print(f"OK: {path}")
              except Exception as e:
                  print(f"ERRO em {path}: {e}")
                  erros = True

          if erros:
              sys.exit(1)
          EOF

      - name: Build da imagem Docker
        run: |
          cd labs/hello-webapp-docker-k8s
          docker build -t hello-webapp:${{ github.sha }} .
```

### Explicando cada etapa

- **Checkout do código**: baixa o repositório para o runner.
- **Configurar Python**: garante Python 3.12 disponível.
- **Instalar dependências**:
  - instala Flask (`requirements.txt`);
  - instala `pytest` e `pyyaml` para testes e validação de YAML.
- **Rodar testes**:
  - executa `pytest`;
  - se algum teste falhar, o job falha e o pipeline para ali.
- **Validar sintaxe YAML**:
  - percorre todos os arquivos `k8s/*.yaml`;
  - tenta carregar o YAML com `yaml.safe_load_all`;
  - se algum arquivo estiver com sintaxe inválida (indentação errada, YAML quebrado, etc.), o job falha.
- **Build da imagem Docker**:
  - faz o build da imagem com o `Dockerfile` do lab;
  - usa a tag `hello-webapp:<SHA do commit>`.

---

## 5. Job 2 – `k8s-apply` (cluster Kind no CI)

O segundo job é responsável por:

- subir um cluster Kubernetes temporário com **Kind** dentro do runner;
- aplicar os manifests do lab (`k8s/deployment.yaml` e `k8s/service.yaml`) nesse cluster;
- listar os pods e serviços criados.

Trecho principal:

```yaml
  k8s-apply:
    runs-on: ubuntu-latest
    needs: test-and-build

    steps:
      - name: Checkout do código
        uses: actions/checkout@v4

      - name: Instalar kubectl
        uses: azure/setup-kubectl@v3
        with:
          version: "latest"

      - name: Criar cluster Kind
        uses: helm/kind-action@v1
        with:
          cluster_name: hello-webapp-ci

      - name: Aplicar manifests no cluster Kind
        run: |
          cd labs/hello-webapp-docker-k8s
          kubectl apply -f k8s/
          echo "---- Recursos aplicados ----"
          kubectl get pods,svc -n default
```

### Pontos importantes

- **`needs: test-and-build`**:
  - o job `k8s-apply` só roda se o job `test-and-build` tiver passado;
  - se os testes falharem, se o YAML estiver inválido ou se o build Docker quebrar, o cluster nem é criado.

- **Instalar kubectl**:
  - usa a action oficial `azure/setup-kubectl` para instalar o `kubectl` na VM.

- **Criar cluster Kind**:
  - usa a action `helm/kind-action` para subir um cluster Kubernetes *in Docker* chamado `hello-webapp-ci`;
  - esse cluster existe apenas durante o job; ao final, o runner é descartado.

- **Aplicar manifests**:
  - executa `kubectl apply -f k8s/` para criar Deployment e Service do lab;
  - mostra um `kubectl get pods,svc` para registrar no log o que foi criado no cluster.

Mesmo que a aplicação use uma imagem que não está publicada em um registry público, o objetivo aqui é:

- garantir que os manifests são aceitos pelo `kubectl`;
- garantir que os tipos (`Deployment`, `Service`) e as versões de API estão corretos;
- começar a praticar a ideia de **testar Kubernetes em um cluster real dentro do pipeline**.

---

## 6. O que esse CI demonstra no meu perfil

Com essa configuração, o pipeline mostra que eu sei:

- estruturar um lab completo com:
  - aplicação Flask;
  - imagem Docker;
  - manifests Kubernetes;
  - testes automatizados;
- configurar **GitHub Actions** para:
  - rodar testes Python com `pytest`;
  - validar sintaxe de manifests YAML com `PyYAML`;
  - buildar imagem Docker;
  - criar um **cluster Kubernetes temporário com Kind** dentro do pipeline;
  - aplicar manifests com `kubectl apply` em um cluster de teste.

Isso é exatamente o tipo de prática que aparece em vagas de DevOps/SRE/Platform Engineer, principalmente quando a empresa usa GitHub como plataforma de código e precisa garantir que:

> “Se alguém mexer no serviço, o código, o Dockerfile e os manifests de Kubernetes continuam saudáveis.”

---

## 7. Próximos passos possíveis

A partir desse CI, posso evoluir o lab para:

- publicar a imagem Docker em um registry (GitHub Container Registry, Docker Hub, etc.);
- adicionar um passo que aguarda o Pod ficar em `Running` e falha se entrar em `CrashLoopBackOff`/`ImagePullBackOff`;
- adicionar validação de melhores práticas de Kubernetes (por exemplo, ferramentas como `kubeconform`, `kubeval`, `datree`, `polaris`);
- futuramente, adaptar o mesmo fluxo para clusters gerenciados (EKS, AKS, GKE), seguindo o mesmo conceito de aplicar manifests via CI/CD.
