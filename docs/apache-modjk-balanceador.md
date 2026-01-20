# Apache HTTPD como Balanceador com mod_jk

Autor: Otávio Azevedo  

Este documento resume, em alto nível, a minha experiência configurando o **Apache HTTP Server** como balanceador de carga para aplicações Java (Tomcat/JBoss) utilizando o **mod_jk**.

Não é um passo a passo técnico – é um resumo do que eu sei fazer, quando indico essa solução e os pontos de atenção que já enfrentei em produção. :contentReference[oaicite:0]{index=0}  

---

## 1. Quando uso Apache + mod_jk

Eu indico o uso do **Apache + mod_jk** principalmente em cenários como:

- Ambientes legados ou consolidados em **JBoss/Tomcat** usando o conector **AJP 1.3**;
- Sistemas que já nasceram com arquitetura baseada em **AJP** e `mod_jk` (sem intenção de reescrever agora);
- Situações onde já existe um histórico grande de operação em produção com `mod_jk` e a equipe está acostumada com o modelo.

Nesses casos, o Apache fica na frente recebendo as requisições HTTP/HTTPS e distribui a carga via **AJP** para várias instâncias de JBoss/Tomcat.

---

## 2. O que eu entendo do mod_jk (conceitos)

Pontos que eu conheço e sei explicar/trabalhar:

- **AJP (Apache JServ Protocol)**  
  - Protocolo binário otimizado para comunicação Apache ↔ Tomcat/JBoss;  
  - Menos overhead que HTTP puro, com conexões reaproveitadas;  
  - A versão mais usada é a **1.3**, referida como **ajp13**. :contentReference[oaicite:1]{index=1}  

- **Workers**  
  - Cada instância de JBoss/Tomcat é um *worker* (host + porta AJP);  
  - É possível definir templates para reaproveitar configurações (timeout, ping, etc.);  
  - Vários workers formam um grupo de balanceamento (cluster).

- **Balanceamento de carga**  
  - `worker.type=lb` para criar o *load balancer*;  
  - Configuro o balanceador apontando para uma lista de workers (instâncias);  
  - Posso ajustar fatores de peso (*lbfactor*) para dar mais carga a determinados nós.

- **Sticky session**  
  - Uso `sticky_session=True` quando a aplicação precisa que a sessão do usuário seja atendida sempre pela mesma instância;  
  - Já trabalhei com cenários onde a aplicação não estava preparada para sessão compartilhada e o sticky era obrigatório.

- **JK Status Manager**  
  - Ponto web `/jkstatus` que mostra o estado dos workers, quantas requisições, se o nó está em erro etc.;  
  - Configuro com proteção por usuário/senha para evitar exposição indevida. :contentReference[oaicite:2]{index=2}  

---

## 3. O que eu sei configurar na prática

Em ambiente real, já fiz:

- Ajustes de **hardening** no Apache (headers de segurança, esconder versão, desabilitar TRACE, ETag etc.);
- Configuração de **MPM event** com parâmetros ajustados para alto volume de requisições;
- Habilitação de compressão HTTP com **mod_deflate** para reduzir banda (HTML, CSS, JS, JSON, fontes, etc.); :contentReference[oaicite:3]{index=3}  
- Compilação e instalação do **mod_jk** a partir do código‑fonte quando o pacote não existe no repositório da distro (CentOS/RHEL);
- Definição de:
  - Arquivo de **workers** (workers.properties) com diversas instâncias JBoss;
  - Grupo de balanceamento (ex.: `sigeduc_lb`) com várias instâncias atrás;
  - Arquivo de **mapeamento de URLs** (uriworkermap) indicando quais caminhos vão para o cluster, e qual vai para o status;
- Criação de **VirtualHost** Apache apontando para o `JkMountFile` correto e configurando logs separados para o domínio público;
- Configuração de **acesso autenticado** ao `/jkstatus` (AuthType Basic com arquivo de senha específico).

---

## 4. Vantagens que já observei em produção

Na prática, vejo essas vantagens em ambientes que já usam mod_jk:

- **Integração madura com JBoss/Tomcat**  
  - Muito usada há anos em ambientes Java;  
  - Bastante documentação e histórico de produção.

- **Controle fino sobre os nós de aplicação**  
  - Consigo remover/colocar instâncias do pool via configuração;  
  - Visualizo estado e métricas básicas pelo JK Status Manager.

- **Reaproveitamento de infraestrutura existente**  
  - Em vez de trocar tudo para outro balanceador, mantemos Apache + mod_jk e vamos evoluindo aos poucos o entorno (monitoramento, automação etc.).

---

## 5. Quando eu não escolheria mod_jk

Eu **não** costumo indicar mod_jk como primeira escolha quando:

- O ambiente é novo e não tem legado em AJP;
- A aplicação já está preparada para HTTP direto ou containerizada (Docker/Kubernetes);
- A stack está mais alinhada com **reverse proxy HTTP** puro (Nginx, Apache + mod_proxy, ingress controller, etc.).

Nesses casos, **Apache + mod_proxy_balancer** ou Nginx como reverse proxy costumam fazer mais sentido, por serem mais simples e mais alinhados com arquiteturas modernas de microserviços.

---

## 6. Cuidados que eu costumo ter

Alguns pontos que sempre olho:

- **Versão e segurança do AJP**  
  - Ajustar firewall e restrições de rede para que a porta AJP não fique exposta externamente;  
  - Manter JBoss/Tomcat atualizados para evitar vulnerabilidades relacionadas ao AJP.

- **Homogeneidade dos nós de aplicação**  
  - Ao escalar horizontalmente, garantir que todos os servidores do pool tenham:  
    - mesma versão de SO;  
    - mesmo tipo de JBoss/Tomcat;  
    - recursos compatíveis de CPU/RAM. :contentReference[oaicite:4]{index=4}  

- **Logs para troubleshooting**  
  - Apache: `error_log`, `access_log` e `mod_jk.log`;  
  - JBoss/Tomcat: `server.log`, `catalina.out`;  
  - Verificar código HTTP de resposta e mensagens de conexão recusada/timeout.

---

## 7. Como isso entra no meu perfil profissional

De forma resumida, posso dizer que sei:

- Montar **Apache HTTPD como balanceador de carga** utilizando `mod_jk` com AJP para múltiplas instâncias JBoss/Tomcat;
- Ajustar parâmetros de **escala e performance** (MPM event, timeouts, sticky session, etc.);
- Fazer **hardening básico** do Apache e proteger endpoints de administração (`/jkstatus`);
- Documentar e replicar essa configuração para outros ambientes, deixando guias internos para o time.

Esse tipo de solução é especialmente útil em ambientes Java legados ou consolidados, que ainda não migraram para arquiteturas baseadas em containers e precisam de disponibilidade e distribuição de carga com a infraestrutura já existente.
