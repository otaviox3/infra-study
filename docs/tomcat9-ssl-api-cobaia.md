# Configuração de certificado SSL no Tomcat 9 para APIs internas

**Autor:** Otávio Azevedo  

Este documento resume a minha experiência configurando **HTTPS direto no Tomcat 9**
para expor APIs internas com certificado SSL/TLS válido, usando um certificado
wildcard emitido por Autoridade Certificadora pública.

Não é um tutorial passo a passo completo, e sim um resumo técnico do que faço
no dia a dia em ambientes semelhantes ao contexto abaixo.

---

## 1. Cenário de uso

Aplicações de API Java rodando em **Tomcat 9**, expostas em URLs como:

- `https://hml-api.cobaia.gov.br:8443/minha-api/status`
- `https://dev-api.cobaia.gov.br:8443/minha-api/status`
- `https://preprod-api.cobaia.gov.br:8443/minha-api/status`

Objetivo:

- habilitar **HTTPS na porta 8443** direto no Tomcat (sem proxy reverso na frente);
- usar o certificado corporativo wildcard (ex.: `*.cobaia.gov.br`);
- garantir que a API esteja acessível com certificado válido em ambiente de testes,
  homologação e pré-produção.

Pré-requisito importante:

- certificado já preparado em formato **PEM** (`fullchain.pem` + chave privada),
  conforme documentado em  
  `docs/certificados-crt-key-para-pem.md` e gerado, se necessário, com o script  
  `scripts/convert-cert-to-pem.sh`.

---

## 2. Organização dos arquivos de certificado

No servidor onde o Tomcat está instalado (ex.: `/opt/tomcat`), organizo os arquivos
de certificado em um diretório dedicado, por exemplo:

- diretório para certificados:

  - `/opt/certificado/`

- arquivos típicos fornecidos pela AC:

  - `star_cobaia_gov_br.crt` – certificado wildcard do domínio;
  - `DigiCertCA.crt` – certificado intermediário;
  - `TrustedRoot.crt` – certificado raiz;
  - `wildcard.cobaia.gov.br.key` – chave privada correspondente ao wildcard.

Com esses arquivos disponíveis, gero o `fullchain.pem` e ajusto permissões (ver seção
seguinte).

---

## 3. Geração do `fullchain.pem` e permissões

Em um cenário prático, utilizo comandos equivalentes a:

- gerar o `fullchain.pem` concatenando os certificados na ordem correta:

  - certificado wildcard do domínio;
  - certificado intermediário;
  - certificado raiz.

  Exemplo:

  cat /opt/certificado/star_cobaia_gov_br.crt \
      /opt/certificado/DigiCertCA.crt \
      /opt/certificado/TrustedRoot.crt > /opt/certificado/fullchain.pem

- garantir que o usuário do serviço (ex.: `tomcat`) seja o dono dos arquivos:

  sudo chown tomcat:tomcat /opt/certificado/*.pem /opt/certificado/*.key

- restringir permissões:

  sudo chmod 600 /opt/certificado/*.pem /opt/certificado/*.key

Com isso, somente o usuário responsável pelo Tomcat tem acesso à chave privada,
reduzindo riscos de exposição.

---

## 4. Configuração do conector HTTPS no server.xml

Com `fullchain.pem` e a chave privada prontos, configuro o conector HTTPS no
arquivo `server.xml` do Tomcat (por exemplo, em `/opt/tomcat/conf/server.xml`).

Um exemplo de bloco de conector que já utilizei é:

<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
           maxThreads="200" SSLEnabled="true">
    <SSLHostConfig>
        <Certificate certificateFile="/opt/certificado/fullchain.pem"
                     certificateKeyFile="/opt/certificado/wildcard.cobaia.gov.br.key"
                     type="RSA" />
    </SSLHostConfig>
</Connector>

Pontos de atenção:

- port="8443" – porta HTTPS que ficará exposta;
- certificateFile – caminho completo para o `fullchain.pem`;
- certificateKeyFile – caminho completo para a chave privada `.key`;
- o usuário que roda o Tomcat (ex.: `tomcat`) precisa ter permissão de leitura nesses
  arquivos (por isso o chown e o chmod da seção anterior).

---

## 5. Reinício do Tomcat e validação

Após editar o `server.xml`, realizo:

1. Reiniciar o serviço Tomcat, por exemplo:

   sudo systemctl restart tomcat

2. Verificar se a porta 8443 está em escuta, algo como:

   sleep 5
   ss -tulnp | grep 8443

3. Testar a URL da API via navegador ou curl, por exemplo:

   - https://dev-api.cobaia.gov.br:8443/minha-api/status

4. Conferir, pelo navegador, se:

   - o certificado está válido;
   - a cadeia está completa (sem alertas de “certificado desconhecido”);
   - o CN/SAN corresponde ao domínio acessado (ex.: `*.cobaia.gov.br`).

---

## 6. Relação com o restante do ambiente

Essa configuração de SSL direto no Tomcat já foi usada em cenários onde:

- não havia Nginx/Apache como proxy reverso na frente;
- era necessário expor rapidamente uma API de testes/homologação em HTTPS;
- o time de desenvolvimento precisava validar integrações com certificado válido.

Em ambientes mais complexos, essa abordagem pode ser combinada com:

- front-end Nginx/Apache atuando como proxy reverso e terminando o TLS;
- Tomcat respondendo apenas em HTTP interno, atrás do proxy.

Mesmo assim, a experiência com SSL direto no Tomcat ajuda a:

- entender melhor o fluxo de certificados dentro da JVM/Tomcat;
- diagnosticar problemas de porta, permissões e caminhos de arquivos;
- explicar para outros times a diferença entre SSL no proxy e SSL direto na aplicação.

---

## 7. O que isso demonstra no meu perfil

Com essa configuração de SSL no Tomcat 9, eu demonstro:

- capacidade de preparar certificados (`fullchain.pem` + chave privada) em Linux;
- entendimento de permissões e segurança de arquivos sensíveis;
- experiência editando e ajustando o `server.xml` do Tomcat para HTTPS;
- validação prática via linha de comando e navegador (porta, certificado, cadeia);
- visão de como isso se encaixa em arquiteturas maiores com APIs internas e externas.

Este resumo complementa o documento de conversão de certificados PEM e reforça
minha experiência com Java/Tomcat + SSL/TLS em ambiente corporativo.
