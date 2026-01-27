# Repositório de estudos e experiência em Infraestrutura / DevOps

Autor: **Otávio Azevedo**

Objetivo: registrar e organizar meus estudos, laboratórios e resumos técnicos sobre serviços web, monitoramento, autenticação corporativa, balanceadores de carga, CI/CD e automação que utilizo no dia a dia na operação de mais de 100 servidores Linux e Windows em ambiente de produção, com foco em evolução profissional e futuro trabalho remoto.

---

## 📚 Navegação rápida

### 📄 Portfólio (resumo do que eu sei fazer)
- `portfolio.md`

### 🧾 Experiência em ambientes reais de produção
- `docs/production-experience.md`

---

## 🧾 Resumos de configurações reais que já implementei

### Qualidade de código / DevOps

- **SonarQube + GitLab (autenticação / DevOps Integration)**  
  Integração do SonarQube com GitLab (OAuth, tokens, DevOps Platform Integrations).  
  → `docs/sonarqube-gitlab-auth.md`

---

### Wiki corporativa / Aplicações Java

- **XWiki com Tomcat 9 + MariaDB + Apache2 (proxy reverso + HTTPS)**  
  Instalação e publicação do XWiki atrás de Apache2 em ambiente corporativo.  
  → `docs/xwiki-tomcat9-mariadb-apache2.md`

- **XWiki em Debian 12 + Tomcat 9 + MariaDB + Apache2 + LDAP**  
  Instalação completa com autenticação LDAP, proxy reverso e ajustes de URL.  
  → `docs/xwiki-debian12-tomcat9-mariadb-apache2-ldap.md`

---

### Balanceadores de carga (Apache)

- **Apache HTTPD como balanceador para aplicações Java com mod_jk**  
  Uso de AJP 1.3, sticky sessions, JK Status Manager e boas práticas.  
  → `docs/apache-modjk-balanceador.md`

- **Apache HTTPD como balanceador HTTP/HTTPS com mod_proxy / mod_proxy_balancer**  
  Reverse proxy, pools de backends, hardening e proteção de interfaces de administração.  
  → `docs/apache-modproxy-balanceador.md`

---

### Certificados e HTTPS

- **Conversão de certificados .crt e .key em fullchain.pem e privkey.pem**  
  Resumo do processo que uso em produção para preparar certificados para Nginx, Apache, Tomcat e outros serviços.  
  → `docs/certificados-crt-key-para-pem.md`

- **Tomcat 9 + SSL para API (exemplo de aplicação corporativa)**  
  Configuração de certificado SSL no Tomcat 9 para expor uma API segura atrás de proxy.  
  → `docs/tomcat9-ssl-api-atualizado.md`

- **JBoss monolito + SSL (certificado em aplicação legada)**  
  Procedimento para habilitar HTTPS em JBoss monolítico usando key/truststores.  
  → `docs/jboss-ssl-monolito-atualizado.md`

---

### CI/CD e autenticação corporativa

- **Jenkins com PHP 8.3 + LDAP**  
  Instalação e configuração de Jenkins com PHP 8.3, integrações e autenticação LDAP.  
  → `docs/jenkins-php83-ldap-atualizado.md`

---

### Monitoramento

- **Observium (monitoramento de rede e servidores)**  
  Instalação, descoberta de hosts, configuração de alertas e uso em ambiente real.  
  → `docs/observium.md`

- (planejado) **Zabbix – templates, triggers e monitoração de serviços web**  
  → `docs/zabbix.md` *(a criar)*

---

### Autenticação corporativa / LDAP

- (planejado) **XWiki + LDAP focado em autenticação e grupos**  
  → `docs/xwiki-ldap.md`

- (planejado) **Jenkins + LDAP (variações e cenários)**  
  → `docs/jenkins-ldap.md`

---

## 🧪 Labs / estudos práticos

Laboratórios pensados para praticar conceitos modernos (Docker, Kubernetes, etc.) sem perder o foco em infra/DevOps.

- **App web simples em Docker + Kubernetes (kind)**  
  App Flask mínima empacotada em Docker, com imagem própria, rodando em cluster Kubernetes local com kind, usando Deployment, Service (NodePort) e probes de `/health`.  
  → `labs/hello-webapp-docker-k8s/README.md`

*(novos labs serão adicionados aqui à medida que eu for praticando mais coisas, como bancos em Kubernetes, Ingress, logging centralizado, etc.)*

---

## 🧩 Scripts de automação

Scripts que uso para instalar e configurar componentes chatos de preparar na mão.

- **Scripts de instalação PHP 7.4 + OCI8 + PDO_OCI (Ubuntu 22.04 / 24.04+)**  
  Automação de ambiente legado PHP 7.4 com Oracle, incluindo Oracle Instant Client e compilação das extensões.  
  → `scripts/README.md`

---

## 🛠️ Tecnologias presentes neste repositório

**Servidores web**

- Nginx  
- Apache HTTPD  

**Aplicações Java**

- Tomcat  
- JBoss / WildFly  

**Wiki corporativa**

- XWiki (Tomcat + MariaDB + Apache2, com e sem LDAP)  

**Qualidade de código**

- SonarQube integrado ao GitLab  

**SCM / CI/CD**

- GitLab  
- Jenkins  

**Monitoramento**

- Observium  
- Zabbix  

**Balanceadores de carga (Apache)**

- `mod_proxy` / `mod_proxy_balancer` (HTTP/HTTPS)  
- `mod_jk` (AJP 1.3) para Tomcat/JBoss  

**Banco de dados**

- MariaDB  
- PostgreSQL  

**Ambientes legados**

- Integração com Oracle via PHP 7.4 + OCI8/PDO_OCI (scripts de automação)  

**Sistemas operacionais**

- Linux (Ubuntu/Debian e CentOS/RHEL)  
- Windows Server  

---

Este repositório **infra-study** registra meus estudos, laboratórios e resumos técnicos de coisas que eu realmente uso em produção, servindo como meu “caderno de campo” de Infra/DevOps.
