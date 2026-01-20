# Portfólio de Infra / DevOps

Autor: Otávio Azevedo  
Objetivo: Atuar com Infraestrutura / DevOps, focando em serviços web, automação, monitoramento, autenticação corporativa e alta disponibilidade.

---

## SonarQube + GitLab

Experiência na instalação, configuração e integração do **SonarQube** com **GitLab**:

- Ajuste de **Server base URL**, configuração de rede (DNS / `/etc/hosts`) e certificados.
- Criação de **Application OAuth** no GitLab e configuração do SonarQube para autenticação via GitLab (SSO / OAuth2).
- Uso de **Personal Access Tokens** e configuração de **DevOps Platform Integrations → GitLab** no SonarQube.
- Documentação interna completa do processo em guia próprio:  
  *“Integração SonarQube com autenticação no Gitlab – Versão 16.1”*. :contentReference[oaicite:4]{index=4}  

---

## XWiki + Autenticação LDAP

- Instalação e configuração do **XWiki** em ambiente Linux (Debian/Ubuntu).
- Integração com **LDAP** para autenticação centralizada de usuários.
- Ajustes de conexão, filtros de busca, grupos e permissões.
- Manutenção de instância em produção (atualizações, backup, tuning básico).

---

## Observium

- Implantação do **Observium** para monitoramento de rede e servidores.
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

- Instalação e administração de instância **GitLab self-hosted**.
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
- Configuração de módulos (rewrite, ssl, deflate etc.).
- Comparação e migração de cenários Nginx vs Apache conforme necessidade da aplicação.

---

## Balanceadores de Carga (Apache + mod_proxy / mod_jk)

- Configuração do **Apache como balanceador de carga** em dois cenários principais:
  - HTTP/HTTPS usando **mod_proxy / mod_proxy_balancer** para múltiplos backends (APIs, aplicações web, etc.); :contentReference[oaicite:5]{index=5}  
  - Aplicações Java (Tomcat / JBoss) usando **mod_jk** e protocolo **AJP 1.3**, com sticky session e JK Status Manager. :contentReference[oaicite:6]{index=6}  
- Definição de pools de backends, sticky sessions, logs separados e páginas de status/gerenciamento.
- Elaboração de documentação interna sobre:
  - hardening de Apache (headers de segurança, MPM event, compressão com mod_deflate);
  - estratégias de escala vertical e horizontal dos balanceadores;
  - proteção de interfaces administrativas (`/balancer-manager`, `/jkstatus`).

---

## Tomcat

- Instalação e configuração de **Apache Tomcat** em Linux.
- Deploy de aplicações Java (WAR), ajuste de contextos e memória.
- Integração Tomcat + Nginx/Apache (incluindo cenários com mod_jk e mod_proxy_balancer).
- Troubleshooting básico (logs, HTTP 5xx, problemas de conexão e sessão).

---

## JBoss

- Instalação e configuração de instâncias **JBoss / WildFly**.
- Deploy de aplicações Java EE.
- Integração com Apache (mod_jk / HTTP) para exposição externa.
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
- Monitoramento (Observium, Zabbix);
- Qualidade de código e integração com DevOps (SonarQube + GitLab); :contentReference[oaicite:7]{index=7}  
- **Balanceamento de carga com Apache (mod_proxy / mod_proxy_balancer / mod_jk)**;   
- Automação de tarefas rotineiras via scripts em shell.

Este repositório **infra-study** registra meus estudos, laboratórios e resumos técnicos relacionados a essas tecnologias.
