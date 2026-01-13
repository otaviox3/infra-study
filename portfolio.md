# Portfólio de Infra / DevOps

Autor: Otávio Henrique Santana Azevedo  
Local: Salvador – BA  
Objetivo: Atuar com Infraestrutura / DevOps, focando em serviços web, automação e observabilidade.

---

## SonarQube + GitLab

Experiência na instalação, configuração e integração do SonarQube com o GitLab:

- Ajuste de **Server base URL**, configuração de rede (DNS / `/etc/hosts`) e certificados.
- Criação de **Application OAuth** no GitLab e configuração do SonarQube para autenticação via GitLab (SSO / OAuth2).
- Uso de **Personal Access Tokens** e configuração de **DevOps Platform Integrations → GitLab** no SonarQube.
- Documentação interna completa do processo em guia próprio: *“Integração SonarQube com autenticação no Gitlab – Versão 16.1”*. :contentReference[oaicite:0]{index=0}  

---

## XWiki + Autenticação LDAP

- Instalação e configuração do XWiki em ambiente Linux (Debian/Ubuntu).
- Integração com **LDAP** para autenticação centralizada de usuários.
- Ajustes de conexão, filtros de busca, grupos e permissões.
- Manutenção de instância em produção (atualizações, backup, tuning básico).

---

## Observium

- Implantação do Observium para monitoramento de rede e servidores.
- Descoberta automática de hosts, configuração de SNMP e organização por grupos.
- Acompanhamento de gráficos de utilização (CPU, memória, banda, disco).
- Criação de alertas básicos (thresholds) para recursos críticos.

---

## Jenkins (com e sem autenticação LDAP)

- Instalação e configuração do **Jenkins** em servidores Linux.
- Configuração de **pipelines freestyle** e pipelines declarativos simples.
- Integração com **LDAP** para autenticação centralizada quando necessário.
- Integração com Git (GitLab) para disparo de jobs em push/merge.

---

## GitLab

- Instalação e administração de instância GitLab self-hosted.
- Criação e manutenção de **projetos, grupos e permissões**.
- Configuração básica de **runners** (Shell / Docker) para CI/CD.
- Integrações com ferramentas externas (SonarQube, Jenkins, etc.).

---

## Nginx

- Instalação e administração de **Nginx** em servidores Linux.
- Configuração de **virtual hosts**, reverse proxy e HTTPS (TLS/SSL).
- Ajuste de redirects, headers e hardening básico.
- Automação de instalação/ativação via scripts `bash`.

---

## Apache HTTPD

- Instalação e configuração do **Apache HTTP Server**.
- Criação de **vhosts**, proxy para aplicações (Tomcat/JBoss/PHP).
- Configuração de módulos (rewrite, ssl etc.).
- Migração e comparação de cenários Nginx vs Apache.

---

## Tomcat

- Instalação e configuração do **Apache Tomcat** em Linux.
- Deploy de aplicações Java (WAR), ajuste de contextos e memória.
- Integração Tomcat + Nginx/Apache como reverse proxy.
- Troubleshooting básico (logs, HTTP 5xx, problemas de conexão).

---

## JBoss

- Instalação e configuração de instância **JBoss / WildFly**.
- Deploy de aplicações Java EE.
- Integração com servidores web (Apache/Nginx) via HTTP/ajp.
- Gestão de logs, datasources e parâmetros de JVM.

---

## Zabbix

- Instalação e configuração de **Zabbix Server** e agentes.
- Criação de hosts, templates e itens para monitoramento de servidores e serviços.
- Configuração de triggers e actions para alertas.
- Uso de dashboards para acompanhar saúde da infraestrutura.

---

## Resumo

Atuação prática em:

- Sistemas Linux em produção;
- Serviços web (Nginx, Apache, Tomcat, JBoss, XWiki);
- Ferramentas de CI/CD (Jenkins, GitLab);
- Monitoração (Observium, Zabbix);
- Ferramentas de qualidade e integração com DevOps (SonarQube + GitLab);
- Automação de tarefas rotineiras via scripts em shell.

Este repositório **infra-study** registra meus estudos, laboratórios e guias técnicos relacionados a essas tecnologias.
