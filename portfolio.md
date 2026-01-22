# Portfólio de Infra / DevOps

**Autor:** Otávio Azevedo  

**Objetivo:** Atuar com Infraestrutura / DevOps, focando em serviços web, automação,
monitoramento, autenticação corporativa, alta disponibilidade e boa observabilidade
em ambiente Linux/Windows.

---

## SonarQube + GitLab

Experiência na instalação, configuração e integração do **SonarQube** com **GitLab**:

- Ajuste de **Server base URL**, configuração de rede (`DNS` / `/etc/hosts`) e certificados.
- Criação de **Application OAuth** no GitLab e configuração do SonarQube para autenticação
  via GitLab (SSO / OAuth2).
- Uso de **Personal Access Tokens** e configuração de *DevOps Platform Integrations → GitLab*
  no SonarQube.
- Documentação interna completa do processo em guia próprio sobre integração SonarQube + GitLab.

---

## XWiki (Tomcat 9 + MariaDB + Apache2 + LDAP)

Instalação e configuração do **XWiki** em Debian/Ubuntu usando:

- **Tomcat 9** como container de aplicação;  
- **MariaDB** como banco de dados;  
- **Apache2** como proxy reverso com HTTPS (Let’s Encrypt ou certificado corporativo).  

Principais atividades:

- Conclusão do wizard inicial, instalação de *flavor* padrão e preparação da wiki para uso corporativo.
- Integração com **LDAP/Active Directory**:
  - configuração de autenticador LDAP;
  - mapeamento de atributos (login, nome, sobrenome, e-mail, grupos);
  - criação automática de usuários a partir do diretório.
- Ajustes de URLs e comportamento:
  - XWiki respondendo na raiz (`/`, sem `/xwiki` na URL);
  - configuração de `xwiki.home`, `xwiki.url.protocol` e `xwiki.webapppath`.
- Uso de Apache como camada de segurança:
  - HTTPS obrigatório;
  - proxy reverso para o Tomcat;
  - logs dedicados para o domínio da wiki.

---

## Observium

- Implantação do **Observium** para monitoramento de rede e servidores.  
- Descoberta automática de hosts, configuração de **SNMP** e organização por grupos.  
- Acompanhamento de gráficos de utilização (CPU, memória, banda, disco).  
- Criação de **alertas básicos (thresholds)** para recursos críticos.

---

## Jenkins (com e sem autenticação LDAP)

- Instalação e configuração do **Jenkins** em servidores Linux.  
- Configuração de **pipelines freestyle** e pipelines declarativos simples.  
- Integração com **LDAP** para autenticação centralizada quando necessário.  
- Integração com **Git/GitLab** para disparo de jobs em *push* / *merge*.

---

## GitLab

- Instalação e administração de instância **GitLab self-hosted**.  
- Criação e manutenção de projetos, grupos e permissões.  
- Configuração básica de **runners** (Shell / Docker) para CI/CD.  
- Integrações com ferramentas externas (SonarQube, Jenkins, etc.).

---

## Nginx

- Instalação e administração de **Nginx** em servidores Linux.  
- Configuração de **virtual hosts**, *reverse proxy* e HTTPS (TLS/SSL).  
- Ajuste de **redirects**, *headers* e hardening básico.  
- Automação de instalação/ativação via **scripts bash**.

---

## Apache HTTPD

- Instalação e configuração do **Apache HTTP Server**.  
- Criação de **vhosts**, proxy para aplicações (Tomcat/JBoss/PHP).  
- Configuração de módulos (`rewrite`, `ssl`, `deflate` etc.).  
- Comparação e migração de cenários **Nginx vs Apache** conforme necessidade da aplicação.

---

## Balanceadores de Carga (Apache + mod_proxy / mod_jk)

Configuração do **Apache** como balanceador de carga em dois cenários principais:

1. **HTTP/HTTPS usando `mod_proxy` / `mod_proxy_balancer`**  
   - múltiplos backends (APIs, aplicações web, etc.);  
   - definição de pools de backends, *stickiness*, health checks e logs dedicados.

2. **Aplicações Java (Tomcat / JBoss) usando `mod_jk` e protocolo AJP 1.3**  
   - configuração de *workers* e *sticky session*;  
   - uso do **JK Status Manager** para monitorar e ajustar nós.

Documentação interna sobre:

- hardening de Apache (headers de segurança, `MPM event`, compressão com `mod_deflate`);  
- estratégias de escala vertical e horizontal dos balanceadores;  
- proteção de interfaces administrativas (`/balancer-manager`, `/jkstatus`).

---

## Certificados SSL/TLS e cadeia PEM

- Preparação de certificados emitidos por Autoridades Certificadoras para uso em servidores Linux.  
- Conversão de arquivos `.crt` e `.key` em:
  - `fullchain.pem` (certificado do domínio + cadeia intermediária + raiz);
  - `privkey.pem` (chave privada em formato PEM).
- Verificação de certificados e chaves com **OpenSSL** antes de aplicar em produção.  
- Aplicação prática em:
  - servidores Apache e Nginx (HTTPS, reverse proxy, balanceadores);
  - aplicações Java (Tomcat/XWiki/JBoss) expostas via proxy;
  - outros serviços internos que exigem certificados válidos.
- Automação parcial do processo via script **`convert-cert-to-pem.sh`**, padronizando a preparação
  de certificados em múltiplos servidores.

---

## Tomcat 9 (apps Java e SSL para APIs internas)

- Instalação e configuração de **Apache Tomcat 9** em Linux.  
- Deploy de aplicações Java (`.war`), ajuste de contextos e memória.  
- Integração Tomcat + Nginx/Apache (incluindo cenários com `mod_jk` e `mod_proxy_balancer`).  
- Configuração de **HTTPS direto no Tomcat 9** para APIs internas na porta 8443:
  - uso de certificado wildcard corporativo;
  - configuração de `server.xml` com `certificateFile` (`fullchain.pem`)
    e `certificateKeyFile` (chave privada);
  - ajuste de permissões de arquivos de certificado para o usuário do serviço.
- Troubleshooting básico (logs, HTTP 5xx, problemas de conexão e sessão).

---

## JBoss / WildFly

- Instalação e configuração de instâncias **JBoss / WildFly** em Linux.
- Deploy de aplicações Java EE.
- Integração com Apache (`mod_jk` / HTTP) para exposição externa.
- Gestão de logs, datasources e parâmetros de JVM.
- Configuração de **HTTPS na porta 8443** usando:
  - conversão de `fullchain.pem` + `privkey.pem` em `certificado.p12` (PKCS12) e depois `certificado.jks` (JKS);
  - ajuste de permissões do keystore (`chmod 600`, usuário/grupo do serviço);
  - edição do `server.xml` para apontar para o novo `keystoreFile`, `keystorePass` e `keyAlias`.

---

## Zabbix

- Instalação e configuração de **Zabbix Server** e agentes.  
- Criação de hosts, templates e itens para monitoramento de servidores e serviços.  
- Configuração de triggers e actions para alertas.  
- Uso de dashboards para acompanhar saúde da infraestrutura.

---

## Scripts de Automação (PHP 7.4 + Oracle)

Criação de scripts em **bash** para automatizar instalação de:

- PHP 7.4 em Ubuntu 22.04+ e 24.04+;  
- Oracle Instant Client (basic, sdk, sqlplus);  
- extensões **OCI8** e **PDO_OCI** compiladas para PHP 7.4.33.

Focados em ambientes legados que ainda dependem de PHP 7.4 com conexão Oracle,
reduzindo tempo de instalação/reinstalação e padronizando o ambiente.

---

## Resumo de atuação

Atuação prática em:

- Sistemas **Linux** em produção (Debian/Ubuntu, CentOS/RHEL) e **Windows Server**;  
- Serviços web (Nginx, Apache, Tomcat, JBoss, XWiki);  
- Ferramentas de CI/CD (Jenkins, GitLab);  
- Monitoramento (Observium, Zabbix);  
- Qualidade de código e integração com DevOps (SonarQube + GitLab);  
- Balanceamento de carga com Apache (`mod_proxy`, `mod_proxy_balancer`, `mod_jk`);  
- Integração PHP 7.4 + Oracle (OCI8/PDO_OCI) via scripts;  
- Automação de tarefas rotineiras via scripts em shell;  
- Operação e suporte de **mais de 100 servidores Linux e Windows** em conjunto.

Este repositório **infra-study** registra meus estudos, laboratórios e resumos técnicos
relacionados a essas tecnologias, funcionando como meu portfólio técnico em Infra / DevOps.
