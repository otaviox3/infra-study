# CI para o lab hello-webapp com GitHub Actions

Autor: **Otávio Azevedo**

Este documento descreve o pipeline de **Integração Contínua (CI)** que configurei para o laboratório `labs/hello-webapp-docker-k8s`, usando **GitHub Actions**.

O objetivo é:

- garantir que a aplicação Flask do lab continua funcionando (testes automatizados);
- buildar a imagem Docker a cada mudança relevante;
- mostrar, no meu portfólio, que sei configurar um pipeline básico de CI em GitHub Actions.

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

A aplicação é um serviço Flask minimalista com:

- `/` → responde uma mensagem de texto simples;
- `/health` → responde `OK` (usado como healthcheck).

---

## 2. Teste automatizado com pytest

Para garantir que o endpoint `/health` continua funcionando, criei o arquivo:

```text
labs/hello-webapp-docker-k8s/tests/test_app.py
```

Conteúdo (resumido):

```python
import sys
from pathlib import Path

# Garante que a pasta raiz do lab esteja no sys.path
ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from app import app


def test_health_endpoint():
    client = app.test_client()
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.data.decode() == "OK"
```

O que esse teste faz:

- ajusta o `sys.path` para que o Python consiga importar `app.py`;
- cria um cliente de teste do Flask (`app.test_client()`);
- chama a rota `/health`;
- verifica que:
  - o status HTTP é `200`;
  - o corpo da resposta é o texto `"OK"`.

Se essa rota quebrar no futuro (erro, mudança de retorno etc.), o pipeline de CI vai falhar e avisar.

---

## 3. Workflow do GitHub Actions

O workflow do GitHub Actions fica em:

```text
.github/workflows/ci-hello-webapp.yml
```

Conteúdo principal:

```yaml
name: CI - hello-webapp

on:
  push:
    paths:
      - "labs/hello-webapp-docker-k8s/**"
      - ".github/workflows/ci-hello-webapp.yml"
  pull_request:
    paths:
      - "labs/hello-webapp-docker-k8s/**"

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
          pip install pytest

      - name: Rodar testes
        run: |
          cd labs/hello-webapp-docker-k8s
          pytest

      - name: Build da imagem Docker
        run: |
          cd labs/hello-webapp-docker-k8s
          docker build -t hello-webapp:${{ github.sha }} .
```

Explicando cada parte:

### 3.1. Disparo do workflow

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

- O workflow roda automaticamente em:
  - qualquer `push` que altere arquivos do lab `hello-webapp` ou o próprio workflow;
  - qualquer `pull_request` que mexa no lab.
- Isso evita rodar CI desnecessariamente quando eu altero arquivos sem relação com esse lab.

### 3.2. Job e runner

```yaml
jobs:
  test-and-build:
    runs-on: ubuntu-latest
```

- Define um único job chamado `test-and-build`.
- Ele executa em um runner Linux gerenciado pelo próprio GitHub (`ubuntu-latest`).

### 3.3. Checkout do código

```yaml
- name: Checkout do código
  uses: actions/checkout@v4
```

- Faz o download do conteúdo do repositório na máquina do runner para que os próximos passos possam acessar os arquivos.

### 3.4. Configuração do Python

```yaml
- name: Configurar Python
  uses: actions/setup-python@v5
  with:
    python-version: "3.12"
```

- Garante que o runner tenha Python 3.12 instalado.
- Isso é importante para a compatibilidade com Flask 3.x e pytest.

### 3.5. Instalação das dependências

```yaml
- name: Instalar dependências
  run: |
    cd labs/hello-webapp-docker-k8s
    python -m pip install --upgrade pip
    pip install -r requirements.txt
    pip install pytest
```

- Entra na pasta do lab:
  - instala/atualiza `pip`;
  - instala as dependências da aplicação (Flask);
  - instala o `pytest` para rodar os testes.

### 3.6. Execução dos testes

```yaml
- name: Rodar testes
  run: |
    cd labs/hello-webapp-docker-k8s
    pytest
```

- Roda a suíte de testes do lab.
- Se qualquer teste falhar, o job é marcado como `failed` e o workflow fica vermelho, indicando problema na alteração.

### 3.7. Build da imagem Docker

```yaml
- name: Build da imagem Docker
  run: |
    cd labs/hello-webapp-docker-k8s
    docker build -t hello-webapp:${{ github.sha }} .
```

- Faz o build da imagem Docker da aplicação:
  - usa o `Dockerfile` do lab;
  - coloca tag com o SHA do commit (`hello-webapp:<commit>`).
- Mesmo que a imagem não seja enviada para um registry ainda, o build já garante que o `Dockerfile` continua válido.

---

## 4. O que esse CI demonstra sobre minha experiência

Com esse pipeline de CI configurado, eu mostro que:

- sei estruturar um **lab real** com:
  - aplicação Flask;
  - Dockerfile;
  - manifests Kubernetes;
  - testes automatizados em pytest;
- consigo configurar **GitHub Actions** para:
  - disparar workflows em eventos específicos (push/PR em diretórios específicos);
  - preparar ambiente (Python + dependências);
  - rodar testes automatizados e tratar falhas;
  - buildar imagens Docker em um runner Linux;
- estou acostumado a documentar o fluxo de CI de forma clara, voltada para Infra/DevOps.

Esse tipo de configuração aparece com frequência em vagas de DevOps/Infra que usam GitHub como plataforma de código.

---

## 5. Próximos passos possíveis

Futuramente, posso evoluir este pipeline para:

- enviar a imagem Docker para um registry (GitHub Container Registry, Docker Hub, etc.);
- adicionar mais testes (por exemplo, verificar conteúdo da página principal `/`);
- adicionar um job separado para validação de manifests Kubernetes (`kubectl kustomize`, `kubeval`, `helm lint`, etc.);
- usar matrix de versões (diferentes versões de Python ou de dependências).

Por enquanto, este lab já cumpre bem o papel de mostrar **CI básico funcionando em GitHub Actions** para uma aplicação que eu mesmo criei e documentei.
