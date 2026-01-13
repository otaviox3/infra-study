# Apache HTTPD como Balanceador com mod_proxy / mod_proxy_balancer

Autor: Otávio Henrique Santana Azevedo  

Este documento resume, em alto nível, a minha experiência configurando o **Apache HTTP Server**
como balanceador de carga HTTP/HTTPS utilizando **mod_proxy** e **mod_proxy_balancer**.

Não é um passo a passo técnico – é um resumo do que eu sei fazer, quando indico essa solução e os
pontos de atenção que já enfrentei em produção.

---

## 1. Quando uso Apache + mod_proxy_balancer

Eu costumo indicar **Apache + mod_proxy_balancer** quando:

- Tenho **aplicações HTTP/HTTPS** atrás do balanceador (Tomcat, Node.js, APIs, etc.), sem necessidade de AJP;
- Preciso de uma solução de **balanceamento de carga simples, robusta e já incluída no Apache**;
- O ambiente já usa Apache como servidor frontal, e faz sentido aproveitar a mesma stack para balanceamento;
- Quero recursos como:
  - redirecionar HTTP → HTTPS diretamente no VirtualHost;
  - expor um painel de administração (`/balancer-manager`) com visão dos backends. :contentReference[oaicite:1]{index=1}  

É uma solução que funciona muito bem como:

- balanceador na borda (com SSL/TLS);
- ponto de entrada para múltiplos serviços web internos.

---

## 2. O que eu entendo do mod_proxy_balancer (conceitos)

Pontos que eu conheço e já trabalhei:

- **mod_proxy**  
  - Módulo que transforma o Apache em proxy/reverse proxy;
  - Permite encaminhar requisições para backends HTTP/HTTPS.

- **mod_proxy_balancer**  
  - Extensão do mod_proxy para criar um *cluster* de backends;
  - Define um namespace do tipo `balancer://nome_do_cluster/` com vários `BalancerMember`;
  - Possibilidade de configurar algoritmo de balanceamento (`lbmethod`, como `byrequests`).

- **Sticky session**  
  - Uso de `stickysession=JSESSIONID` (ou outro cookie) para manter a sessão do usuário
    sempre no mesmo backend, quando necessário;
  - Uso de `route=srv1`, `route=srv2`, etc. em cada `BalancerMember` para identificar o nó. :contentReference[oaicite:2]{index=2}  

- **Balancer Manager**  
  - Interface web `/balancer-manager` que mostra backends, peso, status, número de requisições;
  - Permite, em tempo de execução, colocar/remover nó do pool, desabilitar um backend com problema, etc.;
  - Sempre configuro com autenticação básica e, se possível, restrição de IP.

---

## 3. O que eu sei configurar na prática

Em ambiente real, já fiz:

- Configuração de **VirtualHost HTTP + HTTPS** onde:
  - A porta 80 faz `Redirect permanent` para 443;
  - A porta 443 termina o TLS (cert, key, chain) e faz o proxy para o cluster. :contentReference[oaicite:3]{index=3}  
- Definição de proxies:

  - `ProxyRequests Off` para não virar proxy aberto;
  - `ProxyPreserveHost On` quando quero manter o header `Host` original para o backend;
  - `ProxyPass` e `ProxyPassReverse` apontando para `balancer://nome_cluster/`.

- Configuração do **cluster** com `<Proxy "balancer://apipreprod_cluster/">` contendo:
  - vários `BalancerMember http://IP:porta route=srvX`;
  - `ProxySet lbmethod=byrequests stickysession=JSESSIONID`.

- Criação de **`/balancer-manager`** com:

  - `SetHandler balancer-manager`;
  - `AuthType Basic`, `AuthUserFile` dedicado;
  - `Require valid-user`, e, quando possível, restrição por IP.

- Logs separados para o domínio balanceado, facilitando troubleshooting.

---

## 4. Vantagens que eu já vi usando mod_proxy_balancer

Na prática, vejo essas vantagens:

- **Simplicidade**  
  - Tudo integrado ao próprio Apache, sem precisar instalar outro load balancer;
  - Configuração em arquivos de texto, fácil de versionar.

- **Versatilidade**  
  - Funciona para praticamente qualquer serviço HTTP/HTTPS (APIs, aplicações web, etc.);
  - Compatível com backends Java, Node.js, PHP, Go, etc.

- **TLS/SSL centralizado**  
  - O Apache termina o HTTPS na borda (certificados, protocolos, ciphers);
  - Os backends internos podem falar HTTP puro.

- **Administração em tempo real**  
  - Com o **Balancer Manager**, dá para:
    - ver se algum backend está sobrecarregado;
    - desativar temporariamente um nó;
    - ajustar peso de balanceamento em produção.

---

## 5. Quando prefiro mod_proxy_balancer em vez de mod_jk

Eu costumo preferir **mod_proxy/mod_proxy_balancer** quando:

- A aplicação não depende especificamente de AJP;
- O ambiente está mais moderno, com APIs HTTP/REST;
- A equipe já está migrando para HTTP puro (ou containers, Kubernetes, etc.);
- Quero evitar a complexidade extra do AJP e manter tudo em HTTP/TLS.

Em resumo:
- **mod_jk** eu deixo mais para ambientes Java legados, baseados em AJP;
- **mod_proxy_balancer** eu uso como padrão para novos serviços HTTP/HTTPS.

---

## 6. Quando eu não indicaria mod_proxy_balancer

Eu tomo cuidado ou não indico essa solução quando:

- O tráfego e a complexidade são tão grandes que justificam um **load balancer dedicado** (F5, HAProxy, Nginx ingress, etc.);
- O ambiente já está padronizado em outro tipo de balanceador (por exemplo, Nginx em todos os frontends);
- A equipe não tem ninguém responsável por cuidar de Apache (atualizações, hardening, tuning).

Também não faz sentido:

- usar Apache + mod_proxy só para redirecionar tráfego simples se já existe uma camada de balanceamento gerenciada pela nuvem (ALB/ELB, Application Gateway etc.);
- expor `/balancer-manager` sem autenticação e restrição de acesso.

---

## 7. Cuidados que eu costumo ter

Alguns pontos que sempre olho em produção:

- **Segurança do painel `/balancer-manager`**  
  - Sempre com senha forte;
  - Idealmente restrito por IP ou rede interna.

- **Hardening de SSL/TLS**  
  - Protocolos permitidos (desativando SSLv3, TLS 1.0/1.1 quando possível);
  - Cipher suites recomendadas;
  - Renovação organizada de certificados.

- **Monitoramento e logs**  
  - acompanhar `error_log` e logs de acesso por domínio;
  - observar códigos 5xx, timeouts e padrões de erro nos backends;
  - confirmar se o sticky está funcionando (sessões não “saltando” de servidor).

---

## 8. Como isso entra no meu perfil profissional

De forma resumida, posso dizer que sei:

- Montar **Apache HTTPD como balanceador de carga** usando `mod_proxy` e `mod_proxy_balancer` para múltiplos backends HTTP/HTTPS;
- Configurar **TLS/SSL**, redirecionamento HTTP→HTTPS, logs dedicados e headers de segurança;
- Implementar **sticky session** baseada em cookie (ex.: `JSESSIONID`) quando a aplicação exige sessão fixa;
- Utilizar e proteger o **Balancer Manager** para administrar o pool de backends;
- Documentar e replicar essa configuração em ambientes diferentes (pré‑produção, produção etc.).

Essa abordagem é especialmente útil em ambientes que:
- usam várias instâncias de aplicação web,
- precisam de distribuição de carga e alta disponibilidade,
- e querem aproveitar o Apache como camada única de entrada (reverse proxy + balanceador + TLS).
