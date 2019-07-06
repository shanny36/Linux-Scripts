#!/bin/bash

## Sanity Checks and automagic
function root-check() {
if [[ "$EUID" -ne 0 ]]; then
  echo "Sorry, you need to run this as root"
  exit
fi
}

## Root Check
root-check

function dist-check() {
  if [ -e /etc/centos-release ]; then
    DISTRO="CentOS"
  elif [ -e /etc/debian_version ]; then
    DISTRO=$( lsb_release -is )
  elif [ -e /etc/arch-release ]; then
    DISTRO="Arch"
  elif [ -e /etc/fedora-release ]; then
    DISTRO="Fedora"
  elif [ -e /etc/redhat-release ]; then
    DISTRO="Redhat"
  else
    echo "Your distribution is not supported (yet)."
    exit
  fi
}

## Check distro
dist-check

## Start Installation Of Packages
function install-essentials() {
  if [ "$DISTRO" == "Ubuntu" ]; then
    apt-get install apache2 mysql-server php7.0 php-curl php-gd php-mbstring php-xml php-xmlrpc php-mysql php-bcmath php-imagick -y
  elif [ "$DISTRO" == "Debian" ]; then
    apt-get install apache2 mysql-server php7.0 php-curl php-gd php-mbstring php-xml php-xmlrpc php-mysql php-bcmath php-imagick -y
  elif [ "$DISTRO" == "Raspbian" ]; then
    apt-get install apache2 mysql-server php7.0 php-curl php-gd php-mbstring php-xml php-xmlrpc php-mysql php-bcmath php-imagick -y
  elif [ "$DISTRO" == "CentOS" ]; then
    yum install apache2 mysql-server php7.0 php-curl php-gd php-mbstring php-xml php-xmlrpc php-mysql php-bcmath php-imagick -y
  elif [ "$DISTRO" == "Fedora" ]; then
    dnf install apache2 mysql-server php7.0 php-curl php-gd php-mbstring php-xml php-xmlrpc php-mysql php-bcmath php-imagick -y
  elif [ "$DISTRO" == "Redhat" ]; then
    dnf install apache2 mysql-server php7.0 php-curl php-gd php-mbstring php-xml php-xmlrpc php-mysql php-bcmath php-imagick -y
  elif [ "$DISTRO" == "Arch" ]; then
    pacman -s
  fi
}

## Install Essentials
install-essentials

## Install Google TCP BBR
function install-bbr() {
  if [ "$DISTRO" == "Ubuntu" ]; then
    wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb
    sudo dpkg -i mod-pagespeed-*.deb
    sudo apt-get -f install
  elif [ "$DISTRO" == "Debian" ]; then
    wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb
    sudo dpkg -i mod-pagespeed-*.deb
    sudo apt-get -f install
  elif [ "$DISTRO" == "Rasbian" ]; then
    wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb
    sudo dpkg -i mod-pagespeed-*.deb
    sudo apt-get -f install
  elif [ "$DISTRO" == "CentOS" ]; then
    wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_x86_64.rpm
    sudo dpkg -i mod-pagespeed-*.deb
    sudo apt-get -f install
  elif [ "$DISTRO" == "Fedora" ]; then
    wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_x86_64.rpm
    sudo dpkg -i mod-pagespeed-*.deb
    sudo apt-get -f install
  fi
}
## Install Google BBR
install-bbr


## Start Installation Of Wordpress
function install-wordpress() {
    cd /tmp
    wget https://wordpress.org/latest.tar.gz
    tar xf latest.tar.gz
    sudo mv /tmp/wordpress/* /var/www/html
}

## Install Wordpresss
install-wordpress

## Enable Mod Rewrite
function mod-rewrite() {
sudo a2enmod rewrite
echo "<Directory /var/www>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    Require all granted
</Directory>" >> /etc/apache2/sites-available/000-default.conf
}

## Run Mode Rewite
mod-rewrite

## Enable htacess
function enable-htacess() {
echo "<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>" >> /var/www/.htaccess
}

## Run Htacess
enable-htacess

## Function for correct permission
function correct-permissions() {
cd var/www
chown www-data:www-data  -R *
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
}

## Run correct permissions 
correct-permissions

## Get Random Password
RANDOM_PASSWORD="$(wget -qO- -t1 -T2 https://www.random.org/passwords/?num=1&len=24&format=plain&rnd=new)"

function mysql-setup() {
sudo mysql_secure_installation
mysql -u root -p
CREATE DATABASE wordpress_database
CREATE USER `wordpress_database_admin`@`localhost` IDENTIFIED BY '$RANDOM_PASSWORD';
GRANT ALL ON wordpress_database.* TO `wordpress_database_admin`@`localhost`;
FLUSH PRIVILEGES;
exit
}

# Run SQL Setup
mysql-setup

## Wordpress Replace Config
function wordpress-config() {
mv var/www/html/wp-config-sample.php var/www/html/wp-config.php 
sed -i 's|database_name_here|wordpress_database|'var/www/html/wp-config.php
sed -i 's|username_here|wordpress_database_admin|'var/www/html/wp-config.php
sed -i 's|password_here|$RANDOM_PASSWORD|'var/www/html/wp-config.php
}

## Wordpress Config Function Running 
wordpress-config

## Restart Apache2
function apache-restart() {
if pgrep systemd-journal; then
  systemctl enable apache2
  systemctl restart apache2
else
   service apache2 restart
fi
}

## Run Apache2 Restart
apache-restart
