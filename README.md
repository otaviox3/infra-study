# infra-study

Repositório de estudos e resumos de experiência em Infraestrutura / DevOps.

Autor: **Otávio Azevedo**

Objetivo: registrar e fazer anotações sobre serviços web, monitoramento,
autenticação corporativa, balanceadores de carga e ferramentas de CI/CD que utilizo
no dia a dia (SonarQube, GitLab, XWiki, Observium, Jenkins, Apache, Nginx, etc.),
na operação de **mais de 100 servidores Linux e Windows** em ambiente de produção,
com foco em evolução profissional.

---

## 📚 Navegação rápida

- 📄 **Portfólio**  
  → [portfolio.md](./portfolio.md)

- 🧾 **Resumos de configurações reais que já implementei**

  - Experiência em ambientes reais de produção (100+ servidores Linux e Windows)  
    → [docs/production-experience.md](./docs/production-experience.md)

  - Conversão de certificados .crt/.key em fullchain.pem + privkey.pem (para HTTPS em Apache/Nginx/etc.)  
    → [docs/certificados-crt-key-para-pem.md](./docs/certificados-crt-key-para-pem.md)

  - SonarQube + GitLab (autenticação / DevOps Integration)  
    → [docs/sonarqube-gitlab-auth.md](./docs/sonarqube-gitlab-auth.md)

  - XWiki com Tomcat 9 + MariaDB + Apache2 (proxy reverso + LDAP)  
    → [docs/xwiki-tomcat9-mariadb-apache2.md](./docs/xwiki-tomcat9-mariadb-apache2.md)

  - Apache HTTPD como balanceador para aplicações Java com mod_jk  
    → [docs/apache-modjk-balanceador.md](./docs/apache-modjk-balanceador.md)

  - Apache HTTPD como balanceador HTTP/HTTPS com mod_proxy / mod_proxy_balancer  
    → [docs/apache-modproxy-balanceador.md](./docs/apache-modproxy-balanceador.md)

  - Scripts de instalação PHP 7.4 + OCI8 + PDO_OCI (Ubuntu 22.04 / 24.04+)  
    → [scripts/README.md](./scripts/README.md)

  - (planejado) XWiki + LDAP focado em autenticação e grupos  
    → `docs/xwiki-ldap.md`

  - (planejado) Observium  
    → `docs/observium.md`

  - (planejado) Jenkins + LDAP  
    → `docs/jenkins-ldap.md`

---

## 🛠️ Tecnologias presentes neste repositório

### Servidores web

- Nginx  
- Apache HTTPD  

### Aplicações Java

- Tomcat  
- JBoss / WildFly  

### Wiki corporativa

- XWiki (Tomcat + MariaDB + Apache2, com LDAP)  

### Qualidade de código

- SonarQube integrado ao GitLab  

### SCM / CI/CD

- GitLab  
- Jenkins  

### Monitoramento

- Observium  
- Zabbix  

### Balanceadores de carga (Apache)

- mod_proxy / mod_proxy_balancer (HTTP/HTTPS)  
- mod_jk (AJP 1.3) para Tomcat/JBoss  

### Banco de dados

- MariaDB  
- PostgreSQL  

### Ambientes legados

- Integração com Oracle via PHP 7.4 + OCI8/PDO_OCI (scripts de automação)  

### Sistemas operacionais

- Linux (Ubuntu/Debian e CentOS/RHEL)  
- Windows Server  

---

Este repositório **infra-study** registra meus estudos, laboratórios e resumos técnicos
de coisas que eu realmente uso em produção, servindo como meu “caderno de campo”
de Infra/DevOps.
