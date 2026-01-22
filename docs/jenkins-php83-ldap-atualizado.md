# Instalação do Jenkins com PHP 8.3, Node.js 20 e autenticação LDAP

**Autor:** Otávio Azevedo  

Este documento resume a minha experiência instalando e configurando um servidor
**Jenkins** em Linux (Oracle Linux 9 / RHEL-like), incluindo:

- preparação de ambiente com **PHP 8.3**, **Node.js 20**, Vue CLI e Java 17;
- instalação e ativação do Jenkins via repositório oficial;
- configuração de **autenticação corporativa via LDAP**;
- criação de jobs com **build parametrizado por BRANCH**, integrados a repositórios Git internos
  e executando passos PHP/Laravel e Node.js.

Não é um tutorial completo linha a linha, e sim um resumo organizado do que faço no dia a dia.

---

## 1. Cenário de uso

- Jenkins rodando em servidor Linux (ex.: Oracle Linux 9);  
- aplicações PHP (ex.: Laravel) + frontend em Node/Vue;  
- autenticação dos usuários do Jenkins feita contra **LDAP corporativo**;  
- repositórios Git internos acessados via HTTP/HTTPS, por exemplo:

  - http://git.cobaia.exemplo.com/grupo/projeto.git

---

## 2. Preparação do servidor

### 2.1. Ajustes iniciais (firewalld)

Em alguns ambientes, o firewall é gerenciado por outra equipe ou por appliance externo.
Quando isso acontece, já precisei:

- checar o status do firewalld;
- parar e desabilitar o serviço, deixando o controle de portas para a camada de rede.

### 2.2. Instalação do PHP 8.3 (Remi + EPEL)

Para suportar aplicações PHP modernas (como Laravel), configurei:

- repositório EPEL e Remi;
- module reset e module enable para o fluxo de PHP 8.3;
- instalação do PHP 8.3 e extensões necessárias.

Ao final, valido com php -v para garantir que a versão correta está ativa.

### 2.3. Node.js 20 e Vue CLI

Para builds frontend, o servidor Jenkins também precisa de Node.js:

- habilito o fluxo de Node.js 20;
- instalo o pacote nodejs;
- em seguida, instalo a Vue CLI globalmente:

  - npm install -g @vue/cli
  - vue --version para verificar.

### 2.4. Java 17

Como Jenkins é uma aplicação Java, preparo o ambiente com Java 17:

- instalação de OpenJDK 17 (ou pacote equivalente);
- verificação com java -version.

---

## 3. Instalação e inicialização do Jenkins

Seguindo o procedimento recomendado pelo projeto Jenkins, utilizo:

- download do arquivo jenkins.repo para /etc/yum.repos.d/;
- importação da chave GPG oficial;
- instalação do pacote jenkins via yum/dnf.

Depois:

- habilito o serviço na inicialização do sistema (systemctl enable jenkins);
- inicio o serviço (systemctl start jenkins);
- confirmo com systemctl status jenkins.

Primeiro acesso:

- via navegador em http://localhost:8080;
- obtenho a senha inicial em:

  - /var/lib/jenkins/secrets/initialAdminPassword

Instalo:

- plugins sugeridos, ou um conjunto customizado de plugins conforme a necessidade;
- usuário administrador (quando opto por criar conta própria em vez de usar apenas o admin padrão).

---

## 4. Autenticação via LDAP

Para integrar o Jenkins ao diretório corporativo, utilizo:

- menu “Gerenciar Jenkins” → “Configurar Segurança Global”;
- em Security Realm, seleciono LDAP.

Exemplo de campos que já configurei (valores fictícios):

- Server: ldap.cobaia.exemplo.com
- Root DN: DC=cobaia,DC=exemplo,DC=com
- User search filter: (sAMAccountName={0})
- Group search base: OU=TI,OU=SEDE,OU=COBAIA,DC=cobaia,DC=exemplo,DC=com
- Manager DN: CN=conta_bind,OU=Usuarios_srv,DC=cobaia,DC=exemplo,DC=com
- Manager Password: credencial fornecida pela equipe de domínio
- Display Name LDAP attribute: displayname
- Email Address LDAP attribute: mail

Validação:

- uso o botão “Test LDAP settings”, informando um usuário/senha de rede;
- verifico retorno de Authentication: successful, User ID, User DN, Display Name, Email.

---

## 5. Autorização: Project-based Matrix

Após integrar o LDAP, uso Project-based Matrix Authorization Strategy para:

- permitir apenas que usuários/grupos específicos tenham acesso ao Jenkins;
- controlar acesso por projeto, delegando permissões de leitura, execução de build, configuração e administração.

Em muitos casos, utilizo:

- “Habilitar segurança baseada em projeto” nas configurações do job;
- “Inheritance Strategy” para herdar permissões do pai;
- adição dos logins de rede ou grupos LDAP responsáveis por aquele projeto.

Também habilito:

- CSRF Protection com a opção de compatibilidade para ambientes atrás de proxy, quando necessário.

---

## 6. Integração Jenkins + Git (repositório interno)

Para conectar o Jenkins a um repositório Git interno, sigo o fluxo:

- configurar as credenciais para acesso HTTP/HTTPS ao Git (usuário/senha ou token);
- no job, em Gerenciamento de código fonte → Git:
  - informar a URL do repositório, por exemplo:  
    http://git.cobaia.exemplo.com/grupo/projeto.git  
  - selecionar as credenciais apropriadas.

Em Branches to build, uso:

- um parâmetro chamado BRANCH (construção parametrizada);
- no campo Branch Specifier, coloco: $BRANCH.

Assim, o mesmo job serve para dev, hml, prod, etc., dependendo do valor informado no parâmetro.

---

## 7. Exemplo de pipeline “freestyle” para aplicação PHP/Laravel + Node

Em jobs de estilo livre, já utilizei a sequência abaixo em Passos de construção → Executar shell:

1. Dependências PHP (Composer):

   composer install

2. Dependências Node:

   npm install

3. Migrações do Laravel:

   php artisan migrate

4. Otimizações de cache do Laravel:

   php artisan optimize

5. Build frontend (Vue/SPA):

   npm run build

Essa sequência garante que:

- backend PHP/Laravel,
- frontend Node/Vue,
- banco de dados

estejam atualizados de acordo com a branch selecionada.

---

## 8. O que isso demonstra no meu perfil

Com essa experiência de Jenkins, eu mostro:

- capacidade de preparar um servidor Jenkins completo com PHP 8.3, Node.js 20, Vue CLI e Java 17;
- instalação e administração do Jenkins via repositório oficial em Linux;
- integração com LDAP corporativo para autenticação e controle de acesso;
- uso de Project-based Matrix Authorization para segurança por projeto;
- integração com repositórios Git internos por HTTP/HTTPS, com credenciais seguras;
- criação de jobs parametrizados por branch (BRANCH) e pipeline de build completo
  para aplicações PHP/Laravel + Node/Vue.

Este resumo complementa os demais documentos do repositório, reforçando minha atuação
em CI/CD e automação em ambientes corporativos.
