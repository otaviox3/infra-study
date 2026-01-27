# Experiência em ambientes reais de produção (100+ servidores)

Autor: **Otávio Azevedo**

Este documento resume, de forma mais técnica e direta, o tipo de ambiente de produção que eu já opero hoje e as responsabilidades que assumi na prática.

---

## Visão geral do ambiente

- **Escala**: mais de **100 servidores** Linux e Windows.
- **Função principal**: sustentação e configuração de serviços web e de infraestrutura para uso interno corporativo.
- **Sistemas operacionais**:
  - Linux (Ubuntu/Debian e CentOS/RHEL);
  - Windows Server (para serviços específicos).
- **Perfil das aplicações**:
  - aplicações web Java (Tomcat, JBoss/WildFly);
  - aplicações PHP (incluindo cenários com Oracle);
  - ferramentas de colaboração, monitoramento, qualidade de código e CI/CD.

---

## Responsabilidades principais

No dia a dia, atuo em:

- Instalação, configuração e manutenção de **serviços web** (Apache, Nginx, Tomcat, JBoss).
- Suporte a equipes de desenvolvimento:
  - subir novas aplicações em servidores;
  - ajustar parâmetros de ambiente (porta, memória, variáveis, conexões com banco etc.);
  - orientação em boas práticas básicas de deploy.
- Configuração e renovação de **certificados TLS/SSL**:
  - preparo de `fullchain.pem` e `privkey.pem`;
  - uso em Nginx, Apache, Tomcat/JBoss e balanceadores.
- Operação de ferramentas de **CI/CD, qualidade de código e SCM**:
  - GitLab, Jenkins, SonarQube.
- **Monitoramento** de infraestrutura:
  - Zabbix e Observium;
  - criação de hosts, templates, triggers e alertas.
- Automação com **shell script** para:
  - instalação de pacotes complexos (PHP 7.4 + Oracle);
  - padronização de ambientes Linux.

---

## Serviços e ferramentas que já mantenho em produção

### 1. Serviços web e aplicação

**Nginx**

- Reverse proxy para aplicações internas.
- Virtual hosts com HTTPS.
- Ajuste de headers, redirects e hardening básico.

**Apache HTTPD**

- VHosts HTTP/HTTPS.
- Reverse proxy para:
  - Tomcat;
  - JBoss;
  - aplicações PHP.
- Ativação e configuração de módulos (`rewrite`, `ssl`, `proxy`, `proxy_balancer`, `jk`, etc.).

**Tomcat**

- Deploy de aplicações Java (WAR).
- Ajustes de contextos, memória da JVM e parâmetros de conector (HTTP/AJP).
- Integração com Apache (mod_proxy, mod_jk).

**JBoss / WildFly**

- Instalação e manutenção de instâncias JBoss monolíticas.
- Deploy de aplicações Java EE.
- Configuração de HTTPS usando key/truststores.
- Integração com Apache.

---

### 2. Wiki corporativa e colaboração

**XWiki**

- Instalação com Tomcat + MariaDB.
- Publicação atrás de Apache2 com HTTPS (proxy reverso).
- Ajuste de URLs (XWiki respondendo na raiz do domínio).
- Integração com **LDAP/Active Directory**:
  - autenticação de usuários;
  - criação automática a partir do diretório;
  - mapeamento de grupos.

---

### 3. Qualidade de código e DevOps

**SonarQube + GitLab**

- Instalação e configuração do SonarQube.
- Integração com GitLab via:
  - Application OAuth;
  - DevOps Platform Integrations;
  - tokens de autenticação.
- Ajuste de URLs, DNS, certificados e permissões de acesso.
- Suporte para que o time de desenvolvimento utilize análise estática no fluxo de CI/CD.

---

### 4. CI/CD e versionamento

**GitLab (self-hosted)**

- Instalação e administração de instância GitLab on-premise.
- Criação de grupos, projetos e controle de permissões.
- Configuração de runners (Shell/Docker) em cenários de CI/CD.

**Jenkins**

- Instalação e gerenciamento de Jenkins em servidores Linux.
- Criação e manutenção de jobs:
  - freestyle;
  - pipelines simples.
- Integração com GitLab para disparar builds em push/merge.
- Cenários com autenticação via LDAP quando necessário.

---

### 5. Monitoramento

**Zabbix**

- Instalação e configuração do Zabbix Server.
- Cadastro de hosts (Linux, Windows, appliances).
- Uso de templates prontos e criação de itens/triggers personalizados.
- Configuração de ações e notificações para alerta em caso de falhas.

**Observium**

- Implantação do Observium para monitoramento de rede e servidores.
- Configuração de SNMP em equipamentos e hosts.
- Organização de dispositivos em grupos/categorias.
- Acompanhamento de gráficos de utilização (CPU, memória, banda, disco).
- Configuração de alertas básicos de disponibilidade e capacidade.

---

### 6. Certificados, HTTPS e segurança básica

- Conversão de certificados (`.crt`, `.key`, cadeia intermediária/raiz) para formatos:
  - `fullchain.pem`;
  - `privkey.pem`.
- Aplicação desses certificados em:
  - Nginx;
  - Apache HTTPD;
  - Tomcat/JBoss;
  - balanceadores de carga.
- Criação de scripts para automatizar a preparação de certificados.
- Configuração básica de segurança em servidores web:
  - redirecionamento HTTP → HTTPS;
  - headers de segurança;
  - proteção de áreas administrativas.

---

### 7. Ambientes legados (PHP + Oracle)

- Scripts de automação para instalação de:
  - PHP 7.4 em Ubuntu (22.04/24.04+);
  - Oracle Instant Client (basic, sdk, sqlplus);
  - extensões **OCI8** e **PDO_OCI** para PHP.
- Foco em sistemas legados que ainda dependem de PHP 7.4 com Oracle.
- Padronização da instalação para reduzir erros manuais e tempo de setup.

---

## Forma de trabalho

Na prática, minha atuação combina:

- **Sustentação** de serviços críticos já em produção;
- **Implantação** de novas ferramentas (XWiki, Observium, SonarQube, Jenkins, GitLab etc.);
- **Automação** de rotinas repetitivas com shell script;
- **Colaboração** com times de desenvolvimento, ajudando a preparar o ambiente certo para as aplicações.

Este documento complementa o `README.md` e o `portfolio.md`, detalhando melhor o tipo de ambiente real que eu já administro hoje.
