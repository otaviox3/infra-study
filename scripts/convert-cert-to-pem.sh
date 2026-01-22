#!/usr/bin/env bash
set -euo pipefail

echo "=============================================================="
echo " Conversão de certificados .crt/.key em fullchain.pem + privkey.pem"
echo "=============================================================="
echo
echo "Este assistente vai te ajudar a gerar dois arquivos no formato PEM:"
echo
echo "  - fullchain.pem  -> certificado do site + certificadoras intermediárias + raiz"
echo "  - privkey.pem    -> chave privada correspondente ao certificado do site"
echo
echo "Você normalmente recebe da Autoridade Certificadora (AC) algo como:"
echo "  - um arquivo .crt do SEU SITE (ex: star.seudominio.com.br.crt)"
echo "  - um ou mais arquivos .crt da CA intermediária (ex: DigiCertCA.crt)"
echo "  - um arquivo .crt da CA raiz (ex: TrustedRoot.crt)"
echo "  - um arquivo .key da sua chave privada (gerado no CSR, ex: seudominio.key)"
echo

read -rp "Diretório onde estão esses arquivos (.crt/.key) [/opt/certificado]: " DIR
DIR=${DIR:-/opt/certificado}

mkdir -p "$DIR"
cd "$DIR"

echo
echo "Arquivos disponíveis em $DIR:"
ls
echo

echo "--------------------------------------------------------------"
echo " 1) Certificado do DOMÍNIO (o certificado do seu site)"
echo "--------------------------------------------------------------"
echo "É o arquivo .crt que representa o seu domínio."
echo "Exemplos:"
echo "  - star.seudominio.com.br.crt"
echo "  - seudominio.com.br.crt"
echo
read -rp "Digite o NOME do certificado do DOMÍNIO (.crt): " DOMAIN_CRT

if [ ! -f "$DOMAIN_CRT" ]; then
  echo "ERRO: arquivo '$DOMAIN_CRT' não encontrado em '$DIR'."
  echo "Verifique o nome e tente novamente."
  exit 1
fi

echo
echo "--------------------------------------------------------------"
echo " 2) Certificado(s) INTERMEDIÁRIO(s) (opcional, mas MUITO comum)"
echo "--------------------------------------------------------------"
echo "São certificados das CAs intermediárias, que assinam o certificado do seu site."
echo "Exemplos de nomes comuns:"
echo "  - DigiCertCA.crt"
echo "  - IntermediateCA.crt"
echo
echo "Se tiver mais de um, digite todos os nomes separados por espaço,"
echo "na ordem em que a própria AC informa."
echo "Se NÃO tiver intermediário, apenas aperte ENTER."
echo
read -rp "Digite o(s) certificado(s) INTERMEDIÁRIO(s) .crt (ou deixe vazio): " INTERMEDIATE || true

echo
echo "--------------------------------------------------------------"
echo " 3) Certificado RAIZ (opcional)"
echo "--------------------------------------------------------------"
echo "É o certificado raiz da Autoridade Certificadora."
echo "Nem sempre é necessário concatenar, depende de como a AC fornece a cadeia."
echo "Exemplo de nome:"
echo "  - TrustedRoot.crt"
echo
echo "Se você não tiver (ou não quiser usar), apenas aperte ENTER."
echo
read -rp "Digite o certificado RAIZ .crt (ou deixe vazio): " ROOT || true

CHAIN_FILES="$DOMAIN_CRT"
[ -n "${INTERMEDIATE:-}" ] && CHAIN_FILES="$CHAIN_FILES $INTERMEDIATE"
[ -n "${ROOT:-}" ] && CHAIN_FILES="$CHAIN_FILES $ROOT"

echo
echo "Arquivos que serão concatenados na seguinte ordem para formar o fullchain.pem:"
for f in $CHAIN_FILES; do
  echo "  - $f"
done

echo
echo "IMPORTANTE:"
echo "  - A ordem correta é: CERTIFICADO DO SITE -> INTERMEDIÁRIOS -> RAIZ"
echo "  - Se algum nome estiver errado, o fullchain.pem vai ficar inválido."
echo
read -rp "Confirmar geração de fullchain.pem com esses arquivos? [s/N]: " CONF
if [[ ! "${CONF:-n}" =~ ^[sS]$ ]]; then
  echo "Operação cancelada."
  exit 1
fi

# Confere se todos os arquivos existem antes de concatenar
for f in $CHAIN_FILES; do
  if [ ! -f "$f" ]; then
    echo "ERRO: arquivo '$f' não existe em '$DIR'."
    echo "Corrija o nome e rode o script novamente."
    exit 1
  fi
done

cat $CHAIN_FILES > fullchain.pem
echo
echo "✅ fullchain.pem criado em: $DIR/fullchain.pem"

echo
echo "--------------------------------------------------------------"
echo " 4) Chave PRIVADA (arquivo .key)"
echo "--------------------------------------------------------------"
echo "Agora vamos pegar a CHAVE PRIVADA que corresponde ao certificado do seu site."
echo
echo "É o arquivo .key que você gerou quando criou o CSR (pedido de certificado)."
echo "Exemplos:"
echo "  - seudominio.com.br.key"
echo "  - star.seudominio.com.br.key"
echo
read -rp "Digite o NOME do arquivo de chave privada (.key): " KEY

if [ ! -f "$KEY" ]; then
  echo "ERRO: arquivo '$KEY' não encontrado em '$DIR'."
  echo "Sem a chave privada correta, o servidor não consegue usar o certificado."
  exit 1
fi

cp "$KEY" privkey.pem
chmod 600 privkey.pem
echo
echo "✅ privkey.pem criado em: $DIR/privkey.pem (permissão 600)"

echo
read -rp "Deseja verificar os arquivos com openssl (recomendado)? [s/N]: " VERIFY
if [[ "${VERIFY:-n}" =~ ^[sS]$ ]]; then
  echo
  echo "---- Verificando fullchain.pem (dados do certificado) ----"
  openssl x509 -noout -text -in fullchain.pem | head -n 20 || true

  echo
  echo "---- Verificando privkey.pem (chave privada) ----"
  openssl rsa -check -in privkey.pem || true
fi

echo
echo "=============================================================="
echo "Tudo pronto!"
echo
echo "Agora você pode usar:"
echo "  - fullchain.pem  -> no parâmetro de certificado (certificado completo)"
echo "  - privkey.pem    -> no parâmetro de chave privada"
echo
echo "Exemplos de uso:"
echo "  - Nginx : ssl_certificate /caminho/fullchain.pem;"
echo "            ssl_certificate_key /caminho/privkey.pem;"
echo "  - Apache: SSLCertificateFile    /caminho/fullchain.pem"
echo "            SSLCertificateKeyFile /caminho/privkey.pem"
echo
echo "=============================================================="
