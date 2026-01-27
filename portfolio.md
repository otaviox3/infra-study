# Portfólio de Infra / DevOps

Autor: **Otávio Azevedo**

Objetivo: atuar com Infraestrutura / DevOps, focando em serviços web, automação, monitoramento, autenticação corporativa, alta disponibilidade e, progressivamente, em ambientes com containers e Kubernetes.

---

## Visão geral da experiência

- Atuação em ambiente corporativo com **100+ servidores** Linux e Windows em produção.
- Responsável por:
  - instalação, configuração e manutenção de serviços web (Apache, Nginx, Tomcat, JBoss, XWiki, Observium, SonarQube, GitLab, Jenkins etc.);
  - suporte a times de desenvolvimento para subir aplicações, ajustar ambiente e cuidar de certificados/HTTPS;
  - automação de tarefas repetitivas com shell script (principalmente em distribuições Ubuntu/Debian e CentOS/RHEL);
  - testes de estresse, monitoramento e troubleshooting de problemas em produção.

---

## SonarQube + GitLab

Experiência na instalação, configuração e integração do SonarQube com GitLab:

- Ajuste de **Server base URL**, configuração de rede (DNS, `/etc/hosts`) e certificados.
- Criação de **Application OAuth** no GitLab e configuração do SonarQube para autenticação via GitLab (SSO / OAuth2).
- Uso de **Personal Access Tokens** e configuração de **DevOps Platform Integrations → GitLab** no SonarQube.
- Documentação interna do processo em guia próprio de integração SonarQube + GitLab.

---

## XWiki (Tomcat 9 + MariaDB + Apache2 + LDAP)

Instalação e configuração do XWiki em ambiente Linux:

- Uso de **Tomcat 9** como container de aplicação.
- **MariaDB** como banco de dados da wiki.
- **Apache2** como proxy reverso com HTTPS na frente do Tomcat.
- Validação de saúde inicial com o wizard do XWiki, flavor padrão e configurações base.

Integração com **LDAP/Active Directory**:

- Configuração de autenticador LDAP.
- Mapeamento de atributos (login, nome, sobrenome, e-mail, grupos).
- Criação automática de usuários a partir do diretório.
- Ajustes de URLs e comportamento:
  - XWiki respondendo em `/` (sem `/xwiki` exposto ao usuário final);
  - configuração de `xwiki.home`, `xwiki.url.protocol` e `xwiki.webapppath`.

Uso de Apache como camada de segurança:

- HTTPS obrigatório.
- Proxy reverso para o Tomcat.
- Logs dedicados para o domínio da wiki.

---

## Observium

- Implantação do **Observium** para monitoramento de rede e servidores.
- Descoberta automática de hosts, configuração de **SNMP** e organização dos dispositivos em grupos.
- Acompanhamento de gráficos de utilização (CPU, memória, banda, disco).
- Criação de alertas básicos (thresholds) para recursos críticos.
- Integração do Observium como fonte de visibilidade para ambiente de produção.

---

## Jenkins (com e sem autenticação LDAP)

- Instalação e configuração de **Jenkins** em servidores Linux.
- Criação de **pipelines freestyle** e pipelines declarativos simples.
- Integração com **LDAP** para autenticação centralizada quando necessário.
- Integração com **GitLab** para disparo de jobs em push/merge.
- Ajustes de plugins, configuração de executores e manutenção de jobs em ambiente real.

---

## GitLab

- Instalação e administração de instância **GitLab self-hosted**.
- Criação e manutenção de **projetos, grupos e permissões**.
- Configuração básica de **runners** (Shell / Docker) para CI/CD.
- Integrações com ferramentas externas (SonarQube, Jenkins, etc.).

---

## Nginx

- Instalação e administração de **Nginx** em servidores Linux.
- Configuração de **virtual hosts**, **reverse proxy** e **HTTPS (TLS/SSL)**.
- Ajuste de redirects, headers (segurança, HSTS, etc.) e hardening básico.
- Automação da instalação/ativação via scripts bash próprios.

---

## Apache HTTPD

- Instalação e configuração de **Apache HTTP Server**.
- Criação de vhosts, reverse proxy para aplicações (Tomcat/JBoss/PHP).
- Configuração de módulos (`rewrite`, `ssl`, `deflate`, etc.).
- Comparação e migração de cenários **Nginx vs Apache** conforme necessidade da aplicação.

---

## Balanceadores de carga (Apache + mod_proxy / mod_jk)

Configuração do Apache como balanceador de carga em dois cenários principais:

1. **HTTP/HTTPS com mod_proxy / mod_proxy_balancer**
   - Balanceamento entre múltiplos backends (APIs, aplicações web).
   - Configuração de pools, sticky sessions quando necessário e health-checks básicos.
   - Criação de páginas de status e logs dedicados por aplicação.

2. **Aplicações Java (Tomcat / JBoss) com mod_jk (AJP 1.3)**
   - Balanceamento via AJP 1.3, com sticky session e uso de **JK Status Manager**.
   - Separação de logs, ajustes de timeouts e parâmetros do conector.

Boas práticas:

- Hardening de Apache (headers de segurança, MPM event, compressão com `mod_deflate`).
- Estratégias de escala vertical e horizontal dos balanceadores.
- Proteção de interfaces administrativas (`/balancer-manager`, `/jkstatus`).

---

## Tomcat

- Instalação e configuração de **Apache Tomcat** em Linux.
- Deploy de aplicações Java (WAR), ajuste de contextos e parâmetros de memória (JVM).
- Integração Tomcat + Nginx/Apache (incluindo cenários com mod_jk e mod_proxy_balancer).
- Troubleshooting básico:
  - análise de logs de aplicação;
  - erros HTTP 5xx;
  - problemas de conexão com backend e sessão.

---

## JBoss / WildFly

- Instalação e configuração de instâncias **JBoss / WildFly**.
- Deploy de aplicações Java EE.
- Integração com Apache (mod_jk / HTTP) para exposição externa.
- Gestão de logs, datasources e parâmetros de JVM.
- Habilitação de HTTPS em aplicações monolíticas usando key/truststores.

---

## Zabbix

- Instalação e configuração de **Zabbix Server** e agentes.
- Criação de hosts, templates e itens para monitoramento de servidores e serviços.
- Configuração de **triggers** e **actions** para alertas.
- Uso de dashboards para acompanhar a saúde da infraestrutura.

---

## Scripts de automação (PHP 7.4 + Oracle)

Criação de scripts em bash para automatizar a instalação de:

- **PHP 7.4** em Ubuntu 22.04+ e 24.04+;
- **Oracle Instant Client** (basic, sdk, sqlplus);
- extensões **OCI8** e **PDO_OCI** compiladas para PHP 7.4.33.

Foco:

- Ambientes legados que ainda dependem de PHP 7.4 com conexão Oracle.
- Evitar repetição manual do processo de download, instalação e configuração.
- Padronizar ambientes e reduzir erros humanos.

---

## Conversão e preparo de certificados

- Conversão de certificados (`.crt`, `.key`, cadeia intermediária/raiz) para:
  - `fullchain.pem`
  - `privkey.pem`
- Uso em:
  - Nginx (`ssl_certificate`, `ssl_certificate_key`);
  - Apache HTTPD (`SSLCertificateFile`, `SSLCertificateKeyFile`);
  - serviços Java atrás de proxy (Tomcat, JBoss);
  - balanceadores Apache/Nginx.
- Criação de script para automatizar geração de `fullchain.pem` + `privkey.pem` a partir de certificados entregues pela Autoridade Certificadora.

---

## Labs e estudos práticos (Docker / Kubernetes)

Além de serviços em produção, estou começando a registrar **labs** para praticar tecnologias modernas:

- **Lab: aplicação web simples em Docker + Kubernetes (kind)**  
  - App Flask mínima empacotada em Docker com imagem própria.  
  - Cluster Kubernetes local criado com kind.  
  - Deployment com réplicas, healthcheck via `/health` (readiness/liveness).  
  - Service tipo NodePort e acesso usando `kubectl port-forward`.  
  - Documentado em: `labs/hello-webapp-docker-k8s/README.md`.

Esse tipo de laboratório mostra que, além de administrar ambientes tradicionais, estou evoluindo para trabalhar com containers e orquestração Kubernetes, mantendo o foco em Infra/DevOps.

---

## Resumo

Atuação prática em:

- Sistemas Linux em produção;
- Serviços web (Nginx, Apache, Tomcat, JBoss, XWiki);
- Ferramentas de CI/CD (Jenkins, GitLab);
- Monitoramento (Observium, Zabbix);
- Qualidade de código e integração com DevOps (SonarQube + GitLab);
- Balanceamento de carga com Apache (`mod_proxy`, `mod_proxy_balancer`, `mod_jk`);
- Integração PHP 7.4 + Oracle (OCI8/PDO_OCI) via scripts;
- Automação de tarefas rotineiras via scripts em shell;
- Início de práticas com Docker e Kubernetes aplicadas a cenários de Infra/DevOps.

Este portfólio resume o que já fiz e o tipo de problema que sei resolver hoje em ambiente de produção e em laboratórios próprios.
