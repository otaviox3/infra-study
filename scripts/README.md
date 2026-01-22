# Scripts de Automação (Infra / DevOps)

Autor: **Otávio Azevedo**

Esta pasta reúne scripts em **bash** que eu utilizo para:

- automatizar instalações repetitivas em servidores Linux;
- padronizar ambientes legados (PHP + Oracle);
- reduzir erro manual em tarefas chatas (certificados, web server, etc.).

Os scripts são voltados principalmente para **laboratórios** e ambientes controlados.
Antes de usar em produção, sempre valido em ambiente de teste.

---

## 📌 Visão geral dos scripts

- `install-nginx.sh`  
  Instala e habilita o **Nginx** em sistemas baseados em Ubuntu (ex.: 25.04).

- `instalar_php7.4.33_oci8_pdo_oci.sh`  
  Prepara um ambiente com **PHP 7.4.33** e extensões **OCI8** / **PDO_OCI** em Ubuntu
  (22.04 / 24.04+), usado para integração com **Oracle** em sistemas legados.

- `instalacao_php74.sh`  
  Faz a instalação completa de **PHP 7.4 + Apache2 + OCI8 + PDO_OCI** em Ubuntu 24.04+,
  incluindo dependências, repositórios e drivers Oracle.

- `convert-cert-to-pem.sh`  
  Script interativo para converter certificados `.crt` + `.key` em
  `fullchain.pem` e `privkey.pem`, explicando o que é cada arquivo
  (certificado do domínio, intermediário, raiz e chave privada).

---

## 🟢 `install-nginx.sh`

Script simples para:

- atualizar a lista de pacotes (`apt update`);
- instalar o pacote `nginx`;
- habilitar o serviço para iniciar com o sistema (`systemctl enable nginx`);
- garantir que o Nginx está instalado e pronto para receber configuração de sites.

### Quando eu uso

- quando preciso subir rápido um **servidor Nginx** em laboratório ou VM nova;
- para testar proxies, balanceadores ou páginas simples de status.

### Uso básico

```bash
cd ~/infra-study
chmod +x scripts/install-nginx.sh
sudo ./scripts/install-nginx.sh
```

---

## 🟠 `instalar_php7.4.33_oci8_pdo_oci.sh`

Script focado em ambientes legados que ainda dependem de **PHP 7.4.33** com Oracle em Ubuntu
(22.04 / 24.04+), automatizando:

- configuração de repositórios necessários;
- instalação do PHP 7.4.33;
- download/instalação do **Oracle Instant Client**;
- compilação e habilitação das extensões:
  - `oci8`
  - `pdo_oci`

### Quando eu uso

- quando preciso recriar um ambiente antigo que depende de PHP 7.4 + Oracle;
- para padronizar a instalação em várias VMs iguais, evitando fazer tudo na mão.

### Uso básico

```bash
cd ~/infra-study
chmod +x scripts/instalar_php7.4.33_oci8_pdo_oci.sh
sudo ./scripts/instalar_php7.4.33_oci8_pdo_oci.sh
```

> O script pode pedir confirmação em alguns passos e pode exigir que os arquivos
> do Oracle Instant Client estejam disponíveis/localizados conforme instruções do próprio script.

---

## 🟡 `instalacao_php74.sh`

Script mais completo, que prepara:

- **PHP 7.4**;
- **Apache2** como servidor web;
- **OCI8** e **PDO_OCI**;
- bibliotecas necessárias para integração com **Oracle**.

Focado em **Ubuntu 24.04+**, pensando em cenários onde:

- a aplicação PHP ainda não foi migrada para versões mais novas;
- é necessário ter **Apache + PHP 7.4 + Oracle** rodando de forma previsível.

### Quando eu uso

- em servidores que precisam rodar uma aplicação legada PHP 7.4;
- quando quero reconstruir o ambiente rapidamente (após recriar a VM, por exemplo).

### Uso básico

```bash
cd ~/infra-study
chmod +x scripts/instalacao_php74.sh
sudo ./scripts/instalacao_php74.sh
```

---

## 🔵 `convert-cert-to-pem.sh`

Script interativo para converter certificados e montar os arquivos `fullchain.pem`
e `privkey.pem` de forma organizada e mais amigável para quem não está acostumado
com a nomenclatura de certificados.

### O que ele faz

- Pergunta o **diretório** onde estão os arquivos de certificado e chave.
- Explica, em linguagem simples, o que é cada coisa:
  - **Certificado do domínio** – exemplo: `meu_dominio.crt` ou `star_meu_dominio.crt`;
  - **Certificados intermediários** – exemplo: `DigiCertCA.crt`, `Intermediate.crt`;
  - **Certificado raiz** – exemplo: `TrustedRoot.crt`;
  - **Chave privada** – exemplo: `meu_dominio.key` ou `wildcard.meu_dominio.key`.
- Monta o `fullchain.pem` na ordem correta:
  1. domínio
  2. intermediário(s)
  3. raiz
- Copia a chave privada escolhida para `privkey.pem` com permissões restritas (`chmod 600`).
- Oferece a opção de validar o `fullchain.pem` com `openssl x509 -noout -text`.

### Quando eu uso

- antes de aplicar certificados em:
  - **Nginx** (`ssl_certificate` / `ssl_certificate_key`);
  - **Apache** (`SSLCertificateFile` / `SSLCertificateKeyFile`);
  - **Tomcat/JBoss** (quando preciso preparar PEM para conversão em `p12`/`jks`);
- quando recebo vários arquivos `.crt` da Autoridade Certificadora e quero garantir
  que o `fullchain.pem` está na ordem certa.

### Uso básico

```bash
cd ~/infra-study
chmod +x scripts/convert-cert-to-pem.sh
./scripts/convert-cert-to-pem.sh
```

O script vai guiando passo a passo, pedindo os nomes dos arquivos e explicando
qual é cada tipo de certificado.

---

## 🧩 Boas práticas ao usar estes scripts

- Sempre testar primeiro em **VM / ambiente de laboratório**;
- Ler o código do script antes de rodar em produção (`cat scripts/nome_do_script.sh`);
- Manter backups ou snapshots da máquina, principalmente em ambientes sensíveis;
- Atualizar os scripts quando houver mudanças de versão de distribuição ou pacotes.

---

Este diretório `scripts/` faz parte do repositório **infra-study** e complementa
os documentos em `docs/`, mostrando que além de configurar serviços manualmente,
também automatizo tarefas repetitivas e padronizo instalações em ambientes Linux.
