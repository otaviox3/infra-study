# XWiki com Tomcat 9 + MariaDB + Apache2

Autor: Otávio Azevedo  

Este documento é um resumo da minha experiência instalando e configurando o **XWiki**
em ambiente Linux usando:

- **Debian 12**;
- **Tomcat 9** como container de aplicação;
- **MariaDB** como banco de dados;
- **Apache HTTPD** como proxy reverso (HTTPS) na frente do Tomcat;
- Integração com **LDAP** (Active Directory) para autenticação de usuários. :contentReference[oaicite:0]{index=0}  

Não é um passo a passo técnico, é um resumo do que eu já implementei e quando eu indicaria
essa arquitetura.

---

## 1. Quando eu uso XWiki + Tomcat9 + MariaDB + Apache2

Eu costumo indicar essa stack quando:

- a organização precisa de uma **wiki corporativa** robusta (documentação, procedimentos, KB);
- o ambiente exige **banco relacional** (MariaDB) em vez de HSQL/H2 embarcado;
- é desejável separar claramente:
  - aplicação Java (Tomcat),
  - banco (MariaDB),
  - camada web/HTTPS (Apache);
- há necessidade de:
  - **autenticação corporativa via LDAP** (AD);
  - certificado válido (Let's Encrypt ou corporativo) e acesso por **HTTPS** com domínio próprio.

Também é uma boa solução para ambientes onde:

- já existe padrão de uso de **MariaDB**;
- o time de infra já administra **Apache** em outras aplicações.

---

## 2. O que eu sei fazer na prática

### 2.1 Instalação do XWiki com Tomcat 9 + MariaDB

No lado da instalação, eu já fiz:

- preparação do **Debian 12** (atualização de pacotes, repositórios adicionais para Tomcat9);
- adição do **repositório oficial do XWiki**, importando a keyring e o `.list` de stable; :contentReference[oaicite:1]{index=1}  
- escolha da **versão específica** do XWiki via `apt-cache policy` e instalação forçada de:
  - `xwiki-common`,
  - `xwiki-mariadb-common`,
  - `xwiki-tomcat9-common`,
  - `xwiki-tomcat9-mariadb`,
  garantindo que todas as partes fiquem na mesma versão;
- definição e proteção da senha do MariaDB usada pelo XWiki.

Depois disso:

- acesso ao wizard em `http://host:8080/xwiki`;
- criação do **usuário administrador local**;
- instalação do **flavor padrão** do XWiki (Standard Flavor), repetindo a instalação até concluir todas as etapas do wizard; :contentReference[oaicite:2]{index=2}  

### 2.2 Configuração de extensões e LDAP

Trabalhos que já realizei na interface do XWiki:

- acesso ao menu **Administer Wiki → Extensions**;
- instalação de:
  - **LDAP Authenticator** (instalação “on farm”);
  - **LDAP Application** (ajustando filtros de pesquisa de extensões, remove “recommended only” etc.); :contentReference[oaicite:3]{index=3}  

No lado de arquivos de configuração:

- edição do `xwiki.cfg` (em `/usr/lib/xwiki/WEB-INF` no cenário do tutorial) para:
  - ativar a classe `org.xwiki.contrib.ldap.XWikiLDAPAuthServiceImpl`;
  - definir `xwiki.authentication.ldap.trylocal`, servidor LDAP, porta, base DN, bind DN, bind password;
  - mapear atributos como `sAMAccountName`, `sn`, `givenName`, `fullname`; :contentReference[oaicite:4]{index=4}  
- ajuste dos campos de **FIELDS MAPPING** na tela de LDAP da administração global
  (nome, sobrenome, e-mail, grupos etc.), com uso de **“save and reset group cache”** antes de testar login. :contentReference[oaicite:5]{index=5}  

Com isso, já validei:

- login com usuário de rede (AD);
- criação automática de usuários no XWiki a partir do LDAP.

### 2.3 Apache2 como proxy reverso HTTPS para o XWiki

Na parte web/proxy, eu já configurei:

- instalação do **Apache2** e **Let’s Encrypt**;
- criação de **VirtualHost HTTP (porta 80)** apenas para redirecionar para HTTPS;
- criação de **VirtualHost HTTPS (porta 443)** com:
  - certificados do Let’s Encrypt (fullchain / privkey);
  - **ProxyPreserveHost On**;
  - `ProxyPass` e `ProxyPassReverse` apontando para `http://127.0.0.1:8080/xwiki/`;
  - logs dedicados (`xwiki-error.log`, `xwiki-access.log`); :contentReference[oaicite:6]{index=6}  
- ativação de módulos Apache necessários:
  - `proxy`, `proxy_http`, `ssl`, `rewrite`.

### 2.4 Integração Tomcat ↔ Apache ↔ XWiki

No Tomcat, já trabalhei com:

- criação de um **Host específico** no `server.xml` com `name` igual ao domínio do XWiki,
  `appBase` apontando para o diretório do XWiki e um `<Context>` com `path=""` e `docBase` correto; :contentReference[oaicite:7]{index=7}  
- uso de link simbólico (`/var/www/xwiki` → diretório do XWiki) para adequar à estrutura de paths;
- ajustes de permissão de arquivos/diretórios para o usuário do Tomcat (com observação de que
  permissões amplas como `777` podem ser úteis em laboratório, mas em produção eu prefiro
  algo mais restrito).

No `xwiki.cfg`, também ajusto:

- `xwiki.home=https://seu-dominio-do-xwiki` para que a wiki gere URLs externas corretas;
- `xwiki.url.protocol=https`;
- `xwiki.webapppath=/` para que o XWiki responda em `/` em vez de `/xwiki`. :contentReference[oaicite:8]{index=8}  

---

## 3. Vantagens dessa arquitetura

Na prática, vejo essas vantagens:

- **Separação clara de responsabilidades**  
  - MariaDB cuida apenas do banco;  
  - Tomcat roda a aplicação XWiki;  
  - Apache serve de camada pública (TLS, proxy, logs, headers).

- **Escalabilidade moderada**  
  - possível tunar Tomcat (heap, threads) e MariaDB separadamente;
  - Apache pode ser substituído por outro proxy na frente se necessário.

- **Segurança e integração corporativa**  
  - Autenticação centralizada via LDAP/AD;
  - HTTPS obrigatório com certificados válidos;
  - possibilidade de ajustes finos de headers, redirects e hardening no Apache.

- **Manutenibilidade**  
  - uso de pacotes oficiais do XWiki (com versões bem definidas);
  - documentação própria da instalação facilita replicar em outros servidores. :contentReference[oaicite:9]{index=9}  

---

## 4. Quando eu não indicaria esse setup

Eu **não** costumo indicar essa arquitetura completa quando:

- é apenas um **laboratório pequeno** ou ambiente temporário:
  - nesse caso, um XWiki mais simples (HSQL/H2, sem Apache na frente) pode ser suficiente;
- a empresa já está toda em **Kubernetes** ou outra plataforma com ingress e BD gerenciados:
  - faria mais sentido adaptar o XWiki para esse padrão, em vez de manter Tomcat/Apache “clássicos”;
- o time não tem quem mantenha Tomcat/Apache/MariaDB:
  - isso exige rotina de patch, monitoramento e backup.

---

## 5. Cuidados que eu costumo ter

Alguns pontos que sempre observo:

- **Versões compatíveis**  
  - checar a matriz de compatibilidade do XWiki (versão do XWiki, do Tomcat, do Java, do MariaDB);

- **Permissões e segurança**  
  - evitar permissões amplas (`chmod 777`) em produção;
  - separar dono/grupo apropriados para diretórios do XWiki e logs.

- **Performance e tuning**  
  - monitorar consumo de memória do Tomcat e do MariaDB;
  - avaliar necessidade de cache e ajuste de conexões.

- **Backup e recuperação**  
  - garantir backup do banco MariaDB e dos arquivos de configuração (`xwiki.cfg`,
    `server.xml`, `sites-available` do Apache).

---

## 6. Como isso entra no meu perfil profissional

De forma resumida, posso dizer que sei:

- Instalar e configurar **XWiki** em **Debian 12** com **Tomcat 9 + MariaDB** a partir dos pacotes oficiais; :contentReference[oaicite:10]{index=10}  
- Concluir o wizard inicial do XWiki, instalar flavor padrão e preparar o ambiente para uso real;
- Integrar **XWiki com LDAP/AD** via extensões e ajustes no `xwiki.cfg`;
- Colocar o XWiki em produção atrás do **Apache2** com HTTPS (Let’s Encrypt) usando proxy reverso;
- Ajustar URLs amigáveis (sem `/xwiki`), `xwiki.home`, `xwiki.url.protocol` e `xwiki.webapppath`;
- Documentar a instalação de forma que outros membros da equipe consigam replicar a solução.

Essa experiência mostra que consigo cuidar de um serviço corporativo completo:
do sistema operacional até a camada de aplicação e autenticação, passando por banco de dados
e proxy reverso.
