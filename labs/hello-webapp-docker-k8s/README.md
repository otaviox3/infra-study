# Lab completo: App Web simples com Docker e Kubernetes (para Infra/DevOps)

Autor: **Otávio Azevedo**

Objetivo deste lab:

- Subir uma aplicação web **bem simples** em um servidor **Ubuntu**.
- Primeiro rodar essa app com **Docker**.
- Depois rodar **a mesma app** dentro de um cluster **Kubernetes** usando **kind**.
- Entender cada etapa como alguém de **infra/DevOps**, sem foco em programação.

A ideia é servir como um passo a passo que eu posso repetir em qualquer VM e também
como documentação para o meu GitHub.

---

## 1. Visão geral do que vou montar

Arquitetura deste lab:

- VM **Ubuntu**.
- Uma aplicação web mínima em **Python + Flask**:
  - responde `"Hello from DevOps lab – Otávio Azevedo!"` em `/`;
  - responde `"OK"` em `/health`.
- Essa aplicação vai rodar:
  1. em um container **Docker** simples;
  2. em um cluster **Kubernetes** criado com **kind** (Kubernetes in Docker).

Arquivos principais do lab:

```text
labs/hello-webapp-docker-k8s/
  app.py             # código mínimo da aplicação
  requirements.txt   # dependência (Flask)
  Dockerfile         # receita da imagem Docker
  k8s/
    deployment.yaml  # Deployment da app no Kubernetes
    service.yaml     # Service para expor a app no cluster
  README.md          # este tutorial
```

---

## 2. Pré-requisitos

- Uma VM **Ubuntu** (22.04, 24.04 ou similar).
- Acesso com `sudo`.
- Git já configurado e repositório `infra-study` clonado (opcional, mas recomendado).

No restante do tutorial, vou assumir que o repositório está em:

```bash
cd ~/infra-study
```

Se estiver em outro caminho, é só adaptar.

---

## 3. Parte A – App simples com Docker

### 3.1. Criar a pasta do laboratório

Dentro do repositório:

```bash
cd ~/infra-study
mkdir -p labs/hello-webapp-docker-k8s
cd labs/hello-webapp-docker-k8s
```

A partir de agora, tudo dessa parte é dentro dessa pasta.

---

### 3.2. Criar a aplicação web mínima (`app.py`)

A ideia aqui **não é virar dev**, é só ter uma app real para empacotar.

Crio o arquivo:

```bash
nano app.py
```

Conteúdo:

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello from DevOps lab – Otávio Azevedo!"

@app.route("/health")
def health():
    return "OK"

if __name__ == "__main__":
    # host=0.0.0.0 permite que o container receba conexão externa
    app.run(host="0.0.0.0", port=5000)
```

O que isso faz:

- Sobe um servidor web simples em Python;
- Porta **5000**;
- Rota `/` → mensagem de boas-vindas;
- Rota `/health` → retorno `OK` (saúde).

---

### 3.3. Criar o arquivo de dependências (`requirements.txt`)

Este arquivo lista o que a aplicação precisa instalar com `pip`.

```bash
nano requirements.txt
```

Conteúdo:

```text
flask==3.0.0
```

Assim, quando a imagem for construída, o Docker sabe que precisa instalar Flask.

---

### 3.4. Criar o Dockerfile

O `Dockerfile` é a “receita” da imagem da aplicação.

```bash
nano Dockerfile
```

Conteúdo:

```dockerfile
# Imagem base: Python já instalado
FROM python:3.12-slim

# Diretório de trabalho dentro do container
WORKDIR /app

# Copia o arquivo de dependências
COPY requirements.txt .

# Instala as dependências da aplicação
RUN pip install --no-cache-dir -r requirements.txt

# Copia o código da aplicação
COPY app.py .

# Expõe a porta usada pelo Flask (informativo)
EXPOSE 5000

# Comando padrão ao iniciar o container
CMD ["python", "app.py"]
```

Explicando as linhas mais importantes:

- `FROM python:3.12-slim` → usa uma imagem oficial do Python leve.
- `WORKDIR /app` → tudo acontece dentro de `/app` no container.
- `COPY requirements.txt .` → leva o arquivo de dependências para dentro da imagem.
- `RUN pip install ...` → instala o Flask.
- `COPY app.py .` → leva o código da aplicação.
- `EXPOSE 5000` → documenta a porta interna do container.
- `CMD ["python", "app.py"]` → diz o que executar quando o container sobe.

---

### 3.5. Instalar Docker no Ubuntu (se ainda não tiver)

Se Docker ainda não estiver instalado:

```bash
sudo apt update
sudo apt install -y docker.io

sudo systemctl enable docker
sudo systemctl start docker
```

Testar:

```bash
sudo docker ps
```

Se listar algo (mesmo vazio) sem erro, é porque o Docker está ok.

---

### 3.6. Build da imagem Docker

Na pasta do lab:

```bash
cd ~/infra-study/labs/hello-webapp-docker-k8s
sudo docker build -t hello-webapp:1.0 .
```

- `-t hello-webapp:1.0` → dá nome e tag para a imagem.
- `.` → usa o Dockerfile da pasta atual.

Verificar se a imagem foi criada:

```bash
sudo docker images | grep hello-webapp
```

---

### 3.7. Rodar a aplicação em Docker

Agora vou subir um container a partir da imagem:

```bash
sudo docker run -d --name hello-webapp-container -p 8080:5000 hello-webapp:1.0
```

Explicando:

- `-d` → modo background (detached);
- `--name hello-webapp-container` → nome do container;
- `-p 8080:5000` → porta 8080 do host → porta 5000 do container;
- `hello-webapp:1.0` → imagem que foi construída.

Ver os containers rodando:

```bash
sudo docker ps
```

---

### 3.8. Testar com curl

No próprio servidor:

```bash
curl http://localhost:8080/
curl http://localhost:8080/health
```

Esperado:

- `/` → `Hello from DevOps lab – Otávio Azevedo!`
- `/health` → `OK`

Se isso funcionou, a parte **Docker** está concluída.  
Agora vamos levar essa mesma app para o Kubernetes.

---

## 4. Parte B – Kubernetes com kind

Agora vamos:

1. Criar um cluster Kubernetes local com **kind**.
2. Carregar a imagem `hello-webapp:1.0` para dentro desse cluster.
3. Subir um **Deployment** + **Service** para a aplicação.
4. Acessar a app via Kubernetes.

---

### 4.1. Instalar kubectl

Baixar e instalar o `kubectl` (cliente do Kubernetes):

```bash
cd ~
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client
```

---

### 4.2. Instalar kind (Kubernetes in Docker)

Baixar o binário do kind:

```bash
cd ~
curl -Lo kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64
chmod +x kind
sudo mv kind /usr/local/bin/
kind version
```

---

### 4.3. Criar o cluster Kubernetes local

```bash
kind create cluster --name lab-k8s
```

Depois:

```bash
kubectl cluster-info
kubectl get nodes
```

Você deve ver um node `lab-k8s-control-plane` pronto.

---

### 4.4. Carregar a imagem Docker no cluster do kind

O kind não vê automaticamente as imagens locais, então precisamos “injetar”:

```bash
cd ~/infra-study/labs/hello-webapp-docker-k8s
sudo docker images | grep hello-webapp

# Carrega a imagem local para dentro do cluster kind
kind load docker-image hello-webapp:1.0 --name lab-k8s
```

Isso faz com que o cluster consiga usar a imagem `hello-webapp:1.0`
sem precisar baixar de um registry externo.

---

## 5. Criar os manifests do Kubernetes (YAML)

Agora vamos criar uma pastinha `k8s/` para organizar os arquivos YAML.

```bash
cd ~/infra-study/labs/hello-webapp-docker-k8s
mkdir -p k8s
cd k8s
```

---

### 5.1. Deployment – dizendo “como” rodar a app

Arquivo: `k8s/deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-webapp
  labels:
    app: hello-webapp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hello-webapp
  template:
    metadata:
      labels:
        app: hello-webapp
    spec:
      containers:
        - name: hello-webapp
          image: hello-webapp:1.0
          ports:
            - containerPort: 5000
          readinessProbe:
            httpGet:
              path: /health
              port: 5000
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /health
              port: 5000
            initialDelaySeconds: 15
            periodSeconds: 20
```

Explicando:

- `kind: Deployment` → recurso que garante as réplicas.
- `replicas: 2` → quero 2 pods rodando dessa app.
- `image: hello-webapp:1.0` → usa a imagem que criamos e carregamos no kind.
- `readinessProbe` → verifica se a app está pronta (usando `/health`).
- `livenessProbe` → verifica se a app está viva (também usando `/health`).

Aplicar o Deployment:

```bash
cd ~/infra-study/labs/hello-webapp-docker-k8s
kubectl apply -f k8s/deployment.yaml
kubectl get deployments
kubectl get pods -o wide
```

---

### 5.2. Service – “mini-load balancer” interno

Arquivo: `k8s/service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-webapp-svc
spec:
  type: NodePort
  selector:
    app: hello-webapp
  ports:
    - port: 80        # porta do serviço dentro do cluster
      targetPort: 5000 # porta do container/pod
      nodePort: 30080  # porta exposta nos nodes (tipo "externa")
```

Explicando:

- `type: NodePort` → expõe o serviço em uma porta alta dos nodes (30080).
- `selector.app: hello-webapp` → aponta para os pods com essa label.
- `port: 80` → porta lógica do Service.
- `targetPort: 5000` → porta verdadeira do container.
- `nodePort: 30080` → porta que será acessível de fora do cluster (no kind).

Aplicar o Service:

```bash
cd ~/infra-study/labs/hello-webapp-docker-k8s
kubectl apply -f k8s/service.yaml
kubectl get svc
```

Você deve ver `hello-webapp-svc` com `PORT(S) 80:30080/TCP`.

---

### 5.3. Acessar a aplicação rodando em Kubernetes

Como o kind roda dentro do Docker, a forma mais simples de acessar é via `kubectl port-forward`:

```bash
kubectl port-forward svc/hello-webapp-svc 8081:80
```

Isso faz:

- porta **8081** na sua VM Ubuntu → porta **80** do Service → pods (porta 5000).

Em outro terminal (ou na sequência), testar:

```bash
curl http://localhost:8081/
curl http://localhost:8081/health
```

Você deve ver as mesmas respostas de antes, mas agora a app está rodando:

- em **2 pods** dentro de um cluster Kubernetes;
- acessada via um **Service**.

Se você der:

```bash
kubectl get pods -o wide
```

Vai ver os pods `hello-webapp-...` e, se matar um pod, o Deployment recria outro:

```bash
kubectl delete pod <nome_do_pod>
kubectl get pods
```

O Kubernetes automaticamente traz de volta a quantidade de réplicas definida (`replicas: 2`).

---

## 6. Limpando o ambiente (se quiser)

Para deletar os recursos da app:

```bash
cd ~/infra-study/labs/hello-webapp-docker-k8s
kubectl delete -f k8s/service.yaml
kubectl delete -f k8s/deployment.yaml
```

Para apagar o cluster kind (se não quiser mais):

```bash
kind delete cluster --name lab-k8s
```

Para parar/remover o container Docker de teste (da parte A):

```bash
sudo docker stop hello-webapp-container
sudo docker rm hello-webapp-container
```

---

## 7. Versionar no GitHub

### 7.1. Verificar status

```bash
cd ~/infra-study
git status
```

Você deve ver `labs/hello-webapp-docker-k8s` como novos arquivos.

### 7.2. Adicionar arquivos

```bash
git add labs/hello-webapp-docker-k8s
```

### 7.3. Commit

```bash
git commit -m "Adiciona lab hello-webapp com Docker e Kubernetes (kind)"
```

### 7.4. Push

```bash
git push
```

---

## 8. O que este lab mostra sobre minha experiência

Com este laboratório, eu mostro que consigo:

- preparar um servidor **Ubuntu** para rodar **Docker**;
- construir uma imagem Docker de uma app simples (Dockerfile);
- publicar a app em um container com mapeamento de porta e health endpoint;
- instalar e usar **kubectl** + **kind** para criar um cluster Kubernetes local;
- carregar uma imagem local para dentro do cluster;
- escrever e aplicar manifests YAML de:
  - **Deployment** (réplicas, probes);
  - **Service** (NodePort);
- testar a aplicação rodando dentro do cluster, usando `kubectl port-forward`;
- documentar tudo em Markdown como prática de Infra/DevOps.

Este lab pode ser referenciado no meu `README.md` ou `portfolio.md` como:
“laboratório de aplicação web simples em Docker + Kubernetes (kind)”.
