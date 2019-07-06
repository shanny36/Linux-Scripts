wget https://raw.githubusercontent.com/LiveChief/Linux-Scripts/master/linux-update.sh
bash linux-update.sh 

apt-get install apache2 mysql-server php7.0 hp-curl php-gd php-mbstring php-xml php-xmlrpc php-mysql

sudo mysql_secure_installation
mysql -u root -p
CREATE DATABASE wordpress;
CREATE USER `wp_admin`@`localhost` IDENTIFIED BY 'yourpass';
GRANT ALL ON wordpress.* TO `wp_admin`@`localhost`;
FLUSH PRIVILEGES;
exit

cd /tmp
wget https://wordpress.org/latest.tar.gz
tar xf latest.tar.gz
sudo mv /tmp/wordpress/* /var/www/html

wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb
sudo dpkg -i mod-pagespeed-*.deb
sudo apt-get -f install
sudo apt-get install mod-pagespeed-beta
systemctl restart apache2
