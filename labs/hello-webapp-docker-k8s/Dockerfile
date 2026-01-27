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
