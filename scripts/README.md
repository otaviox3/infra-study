# Scripts

Autor: Otávio Azevedo  

Este diretório guarda scripts de automação que uso para instalar e configurar
componentes chatos de preparar na mão (PHP + Oracle, etc.).

---

## PHP 7.4 + OCI8 + PDO_OCI – Ubuntu 22.04

**Arquivo sugerido:** `install-php74-oci8-pdo_oci.sh`  

Script que automatiza a instalação do **PHP 7.4** no **Ubuntu 22.04** com as extensões:

- `oci8` (conexão PHP → Oracle);
- `pdo_oci` (PDO para Oracle).

O script:

- adiciona o PPA do PHP 7.4 (`ondrej/php`);
- instala PHP 7.4, dev packages e dependências (`libaio1`, etc.);
- baixa e instala o **Oracle Instant Client 21.3** (basic, sdk, sqlplus);
- compila o módulo `oci8` via **PECL**;
- compila o módulo `pdo_oci` a partir do código-fonte do PHP 7.4.33;
- habilita as extensões no `php.ini` e em `mods-available` para CLI/Apache. :contentReference[oaicite:2]{index=2}  

---

## PHP 7.4 + Apache2 + OCI8 + PDO_OCI – Ubuntu 24.0x e acima

**Arquivo sugerido:** `install-php74-apache2-oci8-pdo_oci-ubuntu24.sh`  

Versão atualizada para **Ubuntu 24.04+**, ajustando:

- dependências para `libaio1t64`;
- mesma lógica de instalação do **Oracle Instant Client 21.3**;
- compilação de `oci8` e `pdo_oci` para PHP 7.4.33;
- criação dos `.ini` de extensão e links em `conf.d` do Apache;
- verificação se o sistema precisa de reboot (`needs-restarting --reboot-required`);
- ajustes finais de `LD_LIBRARY_PATH`, `ORACLE_HOME` e `ldconfig`. :contentReference[oaicite:3]{index=3}  

---

## Observação

Ambos os scripts foram pensados para ambientes em que:

- é necessário manter **PHP 7.4** por causa de sistemas legados;
- a aplicação precisa falar com **Oracle** via OCI8/PDO_OCI;
- você quer evitar repetir manualmente o processo de baixar Instant Client,
  compilar extensões e editar arquivos de configuração.

Use sempre em ambientes de teste primeiro e lembre de revisar questões de
licenciamento do Oracle Instant Client.

