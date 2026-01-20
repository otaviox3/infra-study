# Scripts

## install-php74-oci8-pdo_oci.sh

Instala PHP 7.4 no Ubuntu 22.04 com as extensões **OCI8** e **PDO_OCI**, incluindo:
- repositório PPA do PHP 7.4;
- Oracle Instant Client 21.3 (basic, sdk, sqlplus);
- compilação do módulo `oci8` via PECL;
- compilação do módulo `pdo_oci` a partir do código do PHP 7.4.33;
- habilitação das extensões no `php.ini` e `mods-available`.

Uso típico: ambientes que precisam conectar PHP 7.4 a Oracle de forma repetível e sem sofrimento manual.
