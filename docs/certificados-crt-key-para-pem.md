Conversão de certificados .crt e .key em fullchain.pem e privkey.pem

Autor: Otávio Azevedo

Este documento resume a minha experiência convertendo certificados em ambiente Linux
para uso em servidores web (Apache, Nginx, Tomcat, XWiki, etc.), a partir de arquivos
.crt (certificados) e .key (chave privada), gerando os arquivos:

fullchain.pem – certificado do domínio + cadeia (certificados intermediários + raiz);

privkey.pem – chave privada no formato esperado por diversos serviços.

Não é um tutorial passo a passo, é um resumo do que faço no dia a dia.

1. Quando faço essa conversão

Costumo usar esse procedimento quando:

Recebo da Autoridade Certificadora um conjunto de arquivos:

certificado do domínio (meu_dominio.crt, star_*.crt, etc.);

certificado(s) intermediário(s) (DigiCertCA.crt, Intermediate.crt…);

certificado raiz (TrustedRoot.crt ou similar);

chave privada (.key) gerada na criação do CSR;

Preciso que o serviço aceite arquivos PEM, por exemplo:

Nginx (ssl_certificate / ssl_certificate_key);

Apache HTTPD (SSLCertificateFile / SSLCertificateKeyFile);

aplicações que esperam fullchain.pem + privkey.pem (inclusive alguns containers).

Esse tipo de conversão é comum em:

servidores web de aplicação interna;

balanceadores Apache/Nginx;

serviços Java expostos via proxy (Tomcat, XWiki, JBoss).

2. Organização dos arquivos

Na prática, o fluxo que uso é:

Criar um diretório dedicado para o certificado:

 mkdir -p /opt/certificado
 cd /opt/certificado


Copiar para esse diretório:

o certificado do domínio (meu_dominio.crt);

os certificados intermediários e raiz;

a chave privada (meu_dominio.key ou wildcard.meu_dominio.key).

Conferir o conteúdo do diretório antes de qualquer comando:

 ls -l


Isso evita espalhar arquivos sensíveis (chave privada) pelo sistema e ajuda a manter
organização quando há vários certificados diferentes.

3. Geração do fullchain.pem

O fullchain.pem é gerado concatenando:

Certificado do domínio (sempre primeiro);

Certificado(s) intermediário(s);

Certificado raiz (quando necessário).

Exemplo genérico:

    cat dominio.crt Intermediario.crt Raiz.crt > fullchain.pem


Cuidados:

A ordem é importante: domínio → intermediários → raiz;

É fundamental usar os arquivos corretos entregues pela AC para evitar erros de cadeia
incompleta em navegadores/clients.

Depois de criado, costumo usar:

    openssl x509 -noout -text -in fullchain.pem


para conferir:

CN (Common Name) / SAN do certificado;

datas de validade;

emissor (CA).

4. Criação do privkey.pem

A chave privada geralmente já existe como .key. Eu costumo:

Copiar para privkey.pem:

 cp meu_dominio.key privkey.pem


Ajustar permissões:

 chmod 600 privkey.pem


Conferir a integridade da chave:

 openssl rsa -check -in privkey.pem


Se aparecer algo como RSA key ok, a chave está íntegra.

Em produção, normalmente deixo:

dono: root ou usuário específico do serviço;

permissão: 600 (apenas o dono pode ler).

5. Onde aplico isso no dia a dia

Alguns usos reais:

Nginx

ssl_certificate /caminho/fullchain.pem;

ssl_certificate_key /caminho/privkey.pem;

Apache HTTPD (VirtualHost HTTPS)

SSLCertificateFile apontando para fullchain.pem;

SSLCertificateKeyFile apontando para privkey.pem.

Serviços Java atrás de proxy (Tomcat/XWiki/JBoss) onde o TLS termina no Apache/Nginx.

Com isso, consigo:

padronizar o formato de certificados nos servidores;

evitar problemas de “cadeia incompleta” em browsers;

simplificar a reaplicação do mesmo certificado em vários hosts (desde que o CN/SAN permita).

6. Automação com scripts

Para não repetir manualmente todos os passos, utilizo scripts em shell que:

perguntam o diretório dos arquivos .crt e .key;

pedem o nome do certificado do domínio, intermediários e raiz;

geram automaticamente o fullchain.pem;

copiam a chave privada para privkey.pem com as permissões corretas;

oferecem a opção de verificar os arquivos com openssl.

Um exemplo dessa automação é o script scripts/convert-cert-to-pem.sh deste repositório,
que facilita a vida quando preciso preparar certificados em vários servidores diferentes.

7. O que isso demonstra no meu perfil

Com essa experiência, consigo:

lidar com certificados emitidos por Autoridades Certificadoras públicas;

entender a diferença entre certificado do domínio, intermediário e raiz;

converter e preparar certificados para múltiplos serviços (Apache, Nginx, proxies, aplicações);

automatizar parte desse processo com scripts, reduzindo erro manual e tempo de configuração.
