# infra-study

Repositório de estudos e **resumos de experiência** em Infraestrutura / DevOps.

Autor: **Otávio Azevedo**  

Objetivo: organizar meus labs, registros e anotações sobre serviços web, monitoramento, autenticação corporativa, balanceadores de carga e ferramentas de CI/CD que utilizo no dia a dia (SonarQube, GitLab, XWiki, Observium, Jenkins, Apache, Nginx, etc.), com foco em evolução profissional e futuro trabalho remoto.

---

## 📚 Navegação rápida

- 📄 **Portfólio (resumo do que eu sei fazer)**  
  → [portfolio.md](./portfolio.md)

- 🧾 **Resumos de configurações reais que já implementei**

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

- Servidores web: **Nginx, Apache HTTPD**
- Aplicações Java: **Tomcat, JBoss/WildFly**
- Wiki corporativa: **XWiki** (Tomcat + MariaDB + Apache2, com LDAP)
- Qualidade de código: **SonarQube**, integrado ao **GitLab**
- SCM / CI/CD: **GitLab, Jenkins**
- Monitoramento: **Observium, Zabbix**
- Balanceadores de carga:
  - Apache HTTPD com **mod_proxy / mod_proxy_balancer** (HTTP/HTTPS)
  - Apache HTTPD com **mod_jk** (AJP 1.3) para Tomcat/JBoss
- Banco de dados: **MariaDB**
- Integração com **Oracle** via PHP 7.4 + OCI8/PDO_OCI (scripts de automação)
- Sistema operacional: **Linux (Ubuntu/Debian e CentOS/RHEL)**

---

## 🔄 Como uso este repositório

- Estudo ~2h por dia (seg–sex);
- Cada laboratório ou experiência relevante gera pelo menos **1 commit**;
- Sempre que configuro algo importante em produção (SonarQube, XWiki, Jenkins, balanceadores, PHP+Oracle, etc.), crio um **resumo** aqui em vez de expor o tutorial completo.

Este repo é o meu “caderno de campo” de Infra/DevOps – focado em mostrar o que eu sei fazer e em manter minha evolução organizada.
