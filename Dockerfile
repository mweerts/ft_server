# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mweerts <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/01/23 18:56:07 by mweerts           #+#    #+#              #
#    Updated: 2020/01/23 21:11:53 by mweerts          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt-get update \
	&& apt-get install -y nginx \
	&& apt-get install -y php-fpm php-mysql\
	&& apt-get install -y mariadb-server \
	&& apt-get install -y wget php php-cgi php-mysqli php-pear php-mbstring php-gettext libapache2-mod-php php-common php-phpseclib php-mysql\
	&& apt-get install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
ADD ./srcs/ /home/

#NGINX

RUN	mkdir /var/www/wordpress \
	&& mv /home/nginx-conf /etc/nginx/sites-available/wordpress \
	&& ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress \
	&& rm /etc/nginx/sites-enabled/default

#MARIADB

RUN	service mysql start \
	&& echo "GRANT ALL ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;" | mysql \
	&& echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql \
	&& echo "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';" | mysql \
	&& echo "FLUSH PRIVILEGES;" | mysql

#PHPMYADMIN

RUN	wget https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-all-languages.tar.gz \
	&& tar xzvf phpMyAdmin-4.9.4-all-languages.tar.gz \
	&& rm phpMyAdmin-4.9.4-all-languages.tar.gz \
	&& mv phpMyAdmin-*/ /usr/share/phpmyadmin/ \
	&& mkdir -p /var/lib/phpmyadmin/tmp \
	&& mkdir /etc/phpmyadmin/ \
	&& mv /home/config.inc.php /usr/share/phpmyadmin/config.inc.php \
	&& ln -s /usr/share/phpmyadmin /var/www/wordpress

#WORDPRESS

RUN	wget https://wordpress.org/latest.tar.gz \
	&& tar xzvf latest.tar.gz \
	&& cp /home/wp-config.php ./wordpress/wp-config.php \
	&& cp -a wordpress/. /var/www/wordpress

EXPOSE 80

CMD service php7.3-fpm start && service mysql start && service nginx restart && tail -f /dev/null

