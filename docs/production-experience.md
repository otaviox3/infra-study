# Experiência em Produção

Autor: Otávio Azevedo  

Este documento resume algumas das plataformas que mantenho em ambiente **real de produção**
no meu trabalho atual (órgão público), sem expor dados sensíveis.

---

## Visão geral da operação

- Responsável por ambientes rodando em **mais de 100 servidores** no total, entre:
  - **Linux** (principalmente para serviços web e ferramentas de desenvolvimento);
  - **Windows Server** (aplicações legadas e serviços de apoio).
- Atuação focada em:
  - serviços web (Apache, Nginx, Tomcat, JBoss, XWiki);
  - ferramentas de desenvolvimento e qualidade (GitLab, Jenkins, SonarQube);
  - monitoramento (Observium, Zabbix);
  - suporte a ambientes legados (PHP 7.4 + Oracle).

---

## XWiki – Wiki Corporativa

**Stack:** Debian, Tomcat 9, XWiki, MariaDB, Apache2 (HTTPS), LDAP/AD  

**O que eu faço:**

- Instalação e atualização do XWiki em servidores Linux.
- Configuração de banco MariaDB dedicado e tuning básico.
- Apache2 como proxy reverso HTTPS na frente do Tomcat.
- Integração com **LDAP/AD** para login único de usuários.
- Backup e acompanhamento de estabilidade do serviço.

**Resultados:**

- Plataforma de documentação interna acessada diariamente por times técnicos e não técnicos.
- Redução de documentação solta em arquivos e e-mails, centralizando tudo no XWiki.

---

## SonarQube + GitLab

**Stack:** SonarQube, GitLab (self-hosted), Linux  

**O que eu faço:**

- Instalação e configuração do SonarQube.
- Integração de autenticação com GitLab (OAuth2 / SSO).
- Configuração de **DevOps Platform Integrations** para o SonarQube falar com a API do GitLab.
- Apoio na configuração de projetos para rodar análise de código a partir do GitLab CI.

**Resultados:**

- Visibilidade de qualidade de código para os times de desenvolvimento.
- Automação de parte das validações de qualidade nos pipelines.

---

## Balanceadores Apache

**Stack:** Apache HTTPD, mod_proxy / mod_proxy_balancer, mod_jk, Tomcat/JBoss  

**O que eu faço:**

- Configuração de Apache como **balanceador de carga**:
  - HTTP/HTTPS com *mod_proxy_balancer* para múltiplos backends;
  - AJP com *mod_jk* para aplicações Java (Tomcat/JBoss).
- Definição de sticky session, pools de servidores e health checks básicos.
- Hardening (headers de segurança, TLS) e proteção de `/balancer-manager` / `/jkstatus`.

**Resultados:**

- Distribuição de carga entre várias instâncias de aplicação.
- Possibilidade de retirar servidores para manutenção sem derrubar o serviço.

---

## Jenkins, GitLab e Integrações

**Stack:** Jenkins, GitLab, Apache/Nginx, Linux  

**O que eu faço:**

- Instalação do Jenkins e configuração de pipelines simples.
- Integração com repositórios GitLab.
- Quando necessário, integração com LDAP para controle de acesso.
- Suporte a times de desenvolvimento na criação de jobs.

---

## PHP 7.4 + Oracle (Ambientes Legados)

**Stack:** Ubuntu, PHP 7.4, Apache2, Oracle Instant Client (OCI8/PDO_OCI)  

**O que eu faço:**

- Criação de **scripts em bash** para automatizar:
  - instalação de PHP 7.4 em versões novas do Ubuntu;
  - instalação e configuração do Oracle Instant Client;
  - compilação das extensões OCI8 e PDO_OCI.
- Uso desses scripts para padronizar o setup em múltiplos servidores.

**Resultados:**

- Redução de tempo e erro humano na montagem de ambientes legados.
- Facilita recriar servidores em casos de migração ou problemas.

---

## Monitoramento

**Stack:** Observium, Zabbix  

**O que eu faço:**

- Configuração de Observium para monitorar switches, servidores e links.
- Uso de Zabbix para monitoramento de serviços (HTTP, banco, etc.).
- Criação de triggers e alertas básicos.

---

> Este documento não descreve tudo em detalhes técnicos (isso está nos tutoriais internos),
> mas deixa claro que não se trata apenas de laboratório: são serviços reais,
> usados por usuários reais, em produção.
