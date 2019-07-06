wget https://raw.githubusercontent.com/LiveChief/Linux-Scripts/master/linux-update.sh
bash linux-update.sh 

apt-get install apache2 mysql-server php7.0 hp-curl php-gd php-mbstring php-xml php-xmlrpc php-mysql php-bcmath php-imagick

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

sudo a2enmod rewrite

echo "<Directory /var/www>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
</Directory>" >> /etc/apache2/sites-available/000-default.conf

systemctl restart apache2

echo "<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>" >> /var/www/.htaccess

systemctl restart apache2

cd var/www
chown www-data:www-data  -R * # Let Apache be owner
find . -type d -exec chmod 755 {} \;  # Change directory permissions rwxr-xr-x
find . -type f -exec chmod 644 {} \;  # Change file permissions rw-r--r--
