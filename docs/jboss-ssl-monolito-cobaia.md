# Configuração de certificado SSL no JBoss para aplicações monolíticas

**Autor:** Otávio Azevedo  

Este documento resume a minha experiência configurando **HTTPS em JBoss** para
aplicações monolíticas Java acessadas na porta 8443, usando certificados emitidos
por Autoridade Certificadora pública.

Não é um tutorial passo a passo completo, e sim um resumo técnico do que faço
no dia a dia em cenários semelhantes ao ambiente descrito abaixo.

---

## 1. Cenário de uso

Aplicações monolíticas rodando em **JBoss** (ex.: `/opt/jboss/server/inst1`),
expostas em URLs como:

- `https://dev-app.cobaia.gov.br:8443/minha-aplicacao`
- `https://hml-app.cobaia.gov.br:8443/minha-aplicacao`
- `https://preprod-app.cobaia.gov.br:8443/minha-aplicacao`

Objetivo:

- habilitar **HTTPS na porta 8443** para esses ambientes;
- usar certificado corporativo válido (wildcard ou específico do host);
- manter o keystore do JBoss atualizado com o novo certificado, substituindo o antigo.

Pré-requisitos principais:

- **OpenSSL** instalado;
- certificado já preparado em formato **PEM** (`fullchain.pem` + `privkey.pem`), conforme
  documentado em `docs/certificados-crt-key-para-pem.md` e, se necessário, gerado com o
  script `scripts/convert-cert-to-pem.sh`.

---

## 2. Organização de diretórios e arquivos

No servidor do JBoss, costumo organizar os arquivos de certificado em:

- diretório de trabalho:

  - `/opt/certificado/`

- arquivos dentro de `/opt/certificado/`:

  - `fullchain.pem` – certificado do domínio + cadeia da AC;
  - `privkey.pem` – chave privada correspondente ao certificado;
  - arquivos gerados durante o processo:
    - `certificado.p12` – keystore em formato PKCS12;
    - `certificado2025.jks` (exemplo) – keystore final em formato JKS.

Passos iniciais que normalmente executo:

```bash
mkdir -p /opt/certificado
cd /opt/certificado
# garantir que o Java está instalado (exemplo em sistemas baseados em dnf/yum)
dnf install -y java-17-openjdk
```

Depois disso, copio `fullchain.pem` e `privkey.pem` para essa pasta.

---

## 3. Conversão de PEM para PKCS12 (`.p12`)

Com `fullchain.pem` e `privkey.pem` na pasta `/opt/certificado`, gero um keystore
PKCS12 com o comando:

```bash
cd /opt/certificado

openssl pkcs12 -export   -in fullchain.pem   -inkey privkey.pem   -out certificado.p12   -name certificado
```

Pontos importantes:

- será solicitada uma **senha** para o arquivo `.p12`;
- o parâmetro `-name certificado` define o **alias** usado dentro do keystore,
  que depois é referenciado no `server.xml` do JBoss (`keyAlias`).

---

## 4. Conversão de PKCS12 (`.p12`) para JKS (`.jks`)

Em seguida, converto o `.p12` para o formato **JKS**, mais comum em ambientes
Java/JBoss mais antigos:

```bash
keytool -importkeystore   -srckeystore certificado.p12   -srcstoretype PKCS12   -destkeystore certificado2025.jks   -deststoretype JKS   -alias certificado
```

Durante esse processo:

- será pedida uma **senha para o keystore JKS** (`certificado2025.jks`);
- também poderá ser solicitada a senha do keystore de origem (o `.p12`).

Ao final, o diretório `/opt/certificado` terá, por exemplo:

- `fullchain.pem`
- `privkey.pem`
- `certificado.p12`
- `certificado2025.jks`

---

## 5. Ajuste de permissões e cópia para o JBoss

Com o keystore `.jks` pronto, sigo para:

1. Copiar o arquivo para o diretório de configuração do JBoss, por exemplo:

   - `/opt/jboss/server/inst1/conf/`

2. Ajustar permissões de forma semelhante ao keystore antigo:

```bash
cd /opt/jboss/server/inst1/conf

chmod 600 certificado2025.jks
chown sistemas:sistemas certificado2025.jks
```

(Os nomes de usuário e grupo podem variar; no meu caso, utilizei algo como `sistemas:sistemas`,
mantendo o mesmo dono e grupo do keystore anterior.)

A ideia é que somente o usuário responsável pelo serviço JBoss consiga ler o keystore.

---

## 6. Atualização do `server.xml` no JBoss

No JBoss monolítico, o conector HTTPS costuma ficar em um arquivo como:

- `/opt/jboss/server/inst1/deploy/jbossweb.sar/server.xml`

Um exemplo de trecho de configuração original poderia ser:

```xml
<!-- SSL/TLS Connector configuration using the admin devl guide keystore -->
<Connector protocol="HTTP/1.1" SSLEnabled="true"
           port="8443" address="${jboss.bind.address}"
           scheme="https" secure="true" clientAuth="false"
           keystoreFile="${jboss.server.home.dir}/conf/keystore.jks"
           keystorePass="senha_antiga"
           sslProtocol="TLS"
           keyAlias="alias_antigo"/>
```

Após gerar o novo keystore, ajusto os atributos para apontar para o `.jks` recém-criado,
a nova senha e o alias especificado no `keytool`:

```xml
<!-- SSL/TLS Connector configuration using the novo keystore -->
<Connector protocol="HTTP/1.1" SSLEnabled="true"
           port="8443" address="${jboss.bind.address}"
           scheme="https" secure="true" clientAuth="false"
           keystoreFile="${jboss.server.home.dir}/conf/certificado2025.jks"
           keystorePass="senha_nova"
           sslProtocol="TLS"
           keyAlias="certificado"/>
```

Pontos de atenção:

- `keystoreFile` deve apontar para o caminho correto do novo `.jks`;
- `keystorePass` deve ser a senha definida na criação do keystore JKS;
- `keyAlias` deve coincidir com o alias usado (`-alias certificado`).

---

## 7. Reinício do JBoss e validação

Depois de atualizar o `server.xml`, os passos de validação que costumo seguir são:

1. **Reiniciar o JBoss:**

```bash
systemctl restart jboss   # ou script próprio de start/stop usado no ambiente
```

2. **Verificar se a porta 8443 está em escuta:**

```bash
sleep 5
ss -tulnp | grep 8443
```

3. **Acessar a aplicação via navegador ou curl**, por exemplo:

- `https://dev-app.cobaia.gov.br:8443/minha-aplicacao`

4. No navegador, confirmar que:

- o certificado está válido;
- a cadeia de certificação está completa;
- o CN/SAN corresponde ao host acessado;
- a data de expiração está compatível com o novo certificado.

---

## 8. Relação com outros componentes do ambiente

Essa configuração de SSL em JBoss monolítico se encaixa em ambientes onde:

- o JBoss expõe diretamente a aplicação na porta 8443; ou
- existe um proxy (Apache/Nginx) em frente, mas o certificado também precisa estar
  atualizado no backend por requisitos internos.

Ela complementa:

- o processo de geração de `fullchain.pem` + `privkey.pem` a partir de arquivos `.crt`/`.key`;
- a configuração de SSL direto no Tomcat 9 para APIs internas;
- o uso de proxies Apache/Nginx com certificados atualizados na borda.

---

## 9. O que isso demonstra no meu perfil

Com essa experiência em JBoss + SSL, eu demonstro:

- capacidade de preparar certificados em formato PEM e convertê-los para PKCS12 (`.p12`)
  e JKS (`.jks`);
- entendimento de permissões e segurança em arquivos sensíveis (chave privada e keystores);
- experiência prática na edição do `server.xml` do JBoss para atualizar keystores e aliases;
- validação ponta a ponta (geração de keystore → configuração do conector → teste via HTTPS);
- atuação em ambientes Java legados com aplicações monolíticas ainda em produção.
