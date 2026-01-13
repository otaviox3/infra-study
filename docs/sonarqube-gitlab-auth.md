# SonarQube + GitLab Authentication (Resumo de Experiência)

Autor: Otávio Henrique Santana Azevedo  
Data: 2025-02-24  
Documento de referência interno: **"Integração SonarQube com autenticação no Gitlab – Versão 16.1"**.

## O que eu sei fazer

- Instalação, configuração básica e administração do **SonarQube** em ambiente Linux.
- Configuração do **Server base URL** e ajustes de rede (DNS ou `/etc/hosts`) para permitir integração com outros serviços.
- Criação de **Application OAuth** no **GitLab** e configuração do SonarQube para usar o GitLab como provedor de autenticação (OAuth2/SSO).
- Habilitar login no SonarQube via **“Log in with GitLab”**, incluindo sincronização opcional de grupos de usuários.
- Criação e uso de **Personal Access Tokens** no GitLab para integração via **DevOps Platform Integrations** (API GitLab).
- Validação e troubleshooting da integração (erros de `redirect_uri`, conectividade SonarQube ↔ GitLab, escopos de token).

## Uso típico

1. Ajustar a URL base do SonarQube e resolução de nome do GitLab.
2. Registrar o SonarQube como aplicação OAuth no GitLab.
3. Configurar a autenticação GitLab em **Administration → Authentication** no SonarQube.
4. Criar um Personal Access Token no GitLab.
5. Configurar **DevOps Platform Integrations → GitLab** no SonarQube.
6. Validar o fluxo de login via botão **“Log in with GitLab”**.

> O passo a passo detalhado, com capturas de tela, está documentado em PDF de uso interno:  
> **"Integração SonarQube com autenticação no Gitlab (Versão 16.1)"**, de minha autoria. :contentReference[oaicite:0]{index=0}
