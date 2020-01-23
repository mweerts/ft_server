mkdir /var/www/ft_server
#mv /home/www/* /var/www/ft_server/
mv /home/nginx-conf /etc/nginx/sites-available/ft_server
ln -s /etc/nginx/sites-available/ft_server /etc/nginx/sites-enabled/ft_server
rm /etc/nginx/sites-enabled/default

#MARIADB
service mysql start
echo "GRANT ALL ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;" | mysql
echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql
echo "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';" | mysql
echo "FLUSH PRIVILEGES;" | mysql

#PHPMYADMIN
cd /home/
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-all-languages.tar.gz
tar xvf phpMyAdmin-4.9.4-all-languages.tar.gz
rm phpMyAdmin-4.9.4-all-languages.tar.gz
mv phpMyAdmin-*/ /usr/share/phpmyadmin/
mkdir -p /var/lib/phpmyadmin/tmp
mkdir /etc/phpmyadmin/
mv /home/config.inc.php /usr/share/phpmyadmin/config.inc.php
ln -s /usr/share/phpmyadmin /var/www/ft_server

#WORDPRESS
cd /tmp/
wget https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
cp /home/wp-config.php /tmp/wordpress/wp-config.php
cp -a /tmp/wordpress/. /var/www/ft_server

#SERVICES
service php7.3-fpm start
service nginx restart
