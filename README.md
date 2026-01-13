# infra-study

Repositório de estudos e **resumos de experiência** em Infraestrutura / DevOps.

Autor: **Otávio Henrique Santana Azevedo**  
Local: Salvador – BA  

Objetivo: organizar meus labs, registros e anotações sobre serviços web, monitoramento, autenticação corporativa, balanceadores de carga e ferramentas de CI/CD que utilizo no dia a dia (SonarQube, GitLab, XWiki, Observium, Jenkins, Apache, Nginx, etc.), com foco em evolução profissional e futuro trabalho remoto.

---

## 📚 Navegação rápida

- 📄 **Portfólio (resumo do que eu sei fazer)**  
  → [portfolio.md](./portfolio.md)

- 🧾 **Resumos de configurações reais que já implementei**

  - SonarQube + GitLab (autenticação / DevOps Integration)  
    → [docs/sonarqube-gitlab-auth.md](./docs/sonarqube-gitlab-auth.md) :contentReference[oaicite:4]{index=4}  

  - Apache HTTPD como balanceador para aplicações Java com mod_jk  
    → [docs/apache-modjk-balanceador.md](./docs/apache-modjk-balanceador.md) :contentReference[oaicite:5]{index=5}  

  - (planejado) XWiki + LDAP  
    → `docs/xwiki-ldap.md`

  - (planejado) Observium  
    → `docs/observium.md`

  - (planejado) Jenkins + LDAP  
    → `docs/jenkins-ldap.md`

---

## 🛠️ Tecnologias presentes neste repositório

- Servidores web: **Nginx, Apache HTTPD**
- Aplicações Java: **Tomcat, JBoss/WildFly**
- Wiki corporativa: **XWiki** (incluindo autenticação LDAP)
- Qualidade de código: **SonarQube**, integrado ao **GitLab**
- SCM / CI/CD: **GitLab, Jenkins**
- Monitoramento: **Observium, Zabbix**
- Balanceadores de carga:
  - Apache HTTPD com **mod_proxy / mod_proxy_balancer**
  - Apache HTTPD com **mod_jk** (AJP 1.3) para Tomcat/JBoss :contentReference[oaicite:6]{index=6}  
- Sistema operacional: **Linux (Ubuntu/Debian e CentOS/RHEL)**

---

## 🔄 Como uso este repositório

- Estudo ~2h por dia (seg–sex);
- Cada laboratório ou experiência relevante gera pelo menos **1 commit**;
- Sempre que configuro algo importante em produção (SonarQube, XWiki, Jenkins, balanceadores, etc.), crio um **resumo** aqui em vez de expor o tutorial completo.

Este repo é o meu “caderno de campo” de Infra/DevOps – focado em mostrar o que eu sei fazer e em manter minha evolução organizada.
