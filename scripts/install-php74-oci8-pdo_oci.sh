#!/bin/bash

# Configuração para modo não interativo
export DEBIAN_FRONTEND=noninteractive
set -e

sudo clear
echo "==========================================="
echo " Instalação PHP 7.4 com OCI8 e PDO OCI"
echo "           Ubuntu 22.04"
echo "==========================================="
echo ""
echo "Este script instalará o PHP 7.4 com as extensões OCI8 e PDO OCI."
echo "Pressione [Enter] para continuar ou [Ctrl+C] para cancelar."
read -r

# Função para forçar execução não interativa
run_noninteractive() {
    sudo env DEBIAN_FRONTEND=noninteractive "$@"
}

# Etapa 1: Atualizando repositórios e pacotes
sudo clear
echo "==========================================="
echo " Atualizando repositórios e pacotes..."
echo "==========================================="
run_noninteractive add-apt-repository -yq ppa:ondrej/php
run_noninteractive apt-get update -yq
run_noninteractive apt-get upgrade -yq

# Etapa 2: Instalando dependências
sudo clear
echo "==========================================="
echo " Instalando dependências necessárias..."
echo "==========================================="
run_noninteractive apt-get install -yq unzip php7.4 php7.4-dev build-essential libaio1 \
php7.4-{json,bcmath,bz2,calendar,ctype,curl,dom,exif,fileinfo,ftp,gd,gettext,iconv,mbstring,mcrypt,mysqli,mysqlnd,pgsql,posix,readline,shmop,soap,sockets,sysvmsg,sysvsem,sysvshm,tokenizer,xml,xmlreader,xmlrpc,xmlwriter,xsl,zip}

# Etapa 3: Habilitando extensões do PHP
sudo clear
echo "==========================================="
echo " Habilitando extensões do PHP..."
echo "==========================================="
sudo phpenmod bcmath bz2 calendar ctype curl dom exif fileinfo ftp gd gettext iconv json mbstring mcrypt mysqli mysqlnd pgsql posix readline shmop soap sockets sysvmsg sysvsem sysvshm tokenizer xml xmlreader xmlrpc xmlwriter xsl zip

# Etapa 4: Baixando Oracle Instant Client
sudo clear
echo "==========================================="
echo " Baixando e instalando o Oracle Instant Client..."
echo "==========================================="
mkdir -p ~/Downloads/oracle && cd ~/Downloads/oracle
wget -q https://download.oracle.com/otn_software/linux/instantclient/213000/instantclient-basic-linux.x64-21.3.0.0.0.zip
wget -q https://download.oracle.com/otn_software/linux/instantclient/213000/instantclient-sdk-linux.x64-21.3.0.0.0.zip
wget -q https://download.oracle.com/otn_software/linux/instantclient/213000/instantclient-sqlplus-linux.x64-21.3.0.0.0.zip

# Etapa 5: Instalando Oracle Instant Client
sudo clear
echo "==========================================="
echo " Instalando o Oracle Instant Client..."
echo "==========================================="
sudo mkdir -p /usr/lib/oracle/21.3/client64
sudo unzip -qo -d /usr/lib/oracle/21.3/client64 instantclient-basic-linux.x64-21.3.0.0.0.zip
sudo unzip -qo -d /usr/lib/oracle/21.3/client64 instantclient-sdk-linux.x64-21.3.0.0.0.zip
sudo unzip -qo -d /usr/lib/oracle/21.3/client64 instantclient-sqlplus-linux.x64-21.3.0.0.0.zip
sudo mv /usr/lib/oracle/21.3/client64/instantclient_21_3 /usr/lib/oracle/21.3/client64/lib

# Etapa 6: Configurando Oracle Instant Client
sudo clear
echo "==========================================="
echo " Configurando Oracle Instant Client..."
echo "==========================================="
echo -e "/usr/lib/oracle/21.3/client64/\n/usr/lib/oracle/21.3/client64/lib" | sudo tee /etc/ld.so.conf.d/oracle.conf
sudo ldconfig

# Etapa 7: Instalando extensão OCI8
sudo clear
echo "==========================================="
echo " Instalando extensão OCI8..."
echo "==========================================="
cd ~
pecl download oci8-2.2.0
tar xzf oci8-2.2.0.tgz
cd oci8-2.2.0
phpize
./configure --with-oci8=instantclient,/usr/lib/oracle/21.3/client64/lib
make
sudo make install
echo "extension=oci8.so" | sudo tee -a /etc/php/7.4/cli/php.ini
echo "extension=oci8.so" | sudo tee /etc/php/7.4/mods-available/oci8.ini
sudo ln -s /etc/php/7.4/mods-available/oci8.ini /etc/php/7.4/apache2/conf.d/20-oci8.ini
sudo systemctl restart apache2

# Etapa 8: Instalando extensão PDO OCI
sudo clear
echo "==========================================="
echo " Instalando extensão PDO OCI..."
echo "==========================================="
cd ~
wget -q https://www.php.net/distributions/php-7.4.33.tar.gz
tar xzvf php-7.4.33.tar.gz
cd php-7.4.33/ext/pdo_oci/
phpize
./configure --with-pdo-oci=instantclient,/usr/lib/oracle/21.3/client64/lib/
make
sudo make install
echo "extension=pdo_oci.so" | sudo tee -a /etc/php/7.4/cli/php.ini
echo "extension=pdo_oci.so" | sudo tee /etc/php/7.4/mods-available/pdo_oci.ini
sudo ln -s /etc/php/7.4/mods-available/pdo_oci.ini /etc/php/7.4/apache2/conf.d/20-pdo_oci.ini
sudo systemctl restart apache2

# Etapa 9: Verifica se o sistema precisa de reinício
sudo clear
echo "==========================================="
echo " Verificando se um reinício do sistema é necessário..."
echo "==========================================="
if sudo needs-restarting --reboot-required > /dev/null 2>&1; then
    echo "Reinício do sistema necessário para aplicar todas as mudanças."
else
    echo "Nenhum reinício do sistema é necessário."
fi

# Etapa 10: Finalização
sudo clear
echo "==========================================="
echo " Instalação concluída com sucesso!"
echo "==========================================="
