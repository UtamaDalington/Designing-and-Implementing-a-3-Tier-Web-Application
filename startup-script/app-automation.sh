#!/bin/bash
# Install and Setup Apache2 and PHP Version 8.2
sudo apt-get -y install apache2
sudo locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
sudo apt-get update 
sudo apt-get install -y software-properties-common
sudo LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php
sudo apt-get update 

# Install PHP 8.2 and required extensions (removed php8.2-json as it's built-in, removed php8.2-mysql duplicate)
sudo apt-get -y install php8.2 php8.2-curl php8.2-bcmath php8.2-intl php8.2-gd php8.2-dom php8.2-iconv php8.2-xsl php8.2-mbstring php8.2-ctype php8.2-zip php8.2-pdo php8.2-xml php8.2-bz2 php8.2-calendar php8.2-exif php8.2-fileinfo php8.2-mysqli php8.2-tokenizer php8.2-xmlwriter php8.2-xmlreader php8.2-phar php8.2-soap php8.2-fpm libapache2-mod-php8.2

# Configure PHP memory limit
sudo sed -i -e"s/^memory_limit\s*=\s*128M/memory_limit = 512M/" /etc/php/8.2/apache2/php.ini

# Install wget
sudo apt-get install wget -y

# Check Apache and PHP Version
apache2 -v
php -v

# Enable Apache modules and restart service
sudo a2enmod rewrite
sudo a2enmod headers
sudo service apache2 restart
sudo service apache2 enable

# Install MySQL client
sudo apt-get -y install mysql-client
mysql --version

# Install AWS CLI
sudo apt-get install awscli -y

# Download the latest WordPress
curl -O https://wordpress.org/latest.tar.gz
sudo tar xzf latest.tar.gz -C /var/www
sudo rm -f latest.tar.gz

# Configure Apache - Download configuration from S3
sudo rm -rf /etc/apache2/sites-enabled/000-default.conf
sudo aws s3 cp s3://3-tier-web-application-4843-5396-4991/apache-config/000-default.conf /etc/apache2/sites-enabled/

# Restart Apache service
sudo service apache2 restart

# Download WordPress configuration from S3
sudo rm -rf /var/www/wordpress/wp-config-sample.php
sudo aws s3 cp s3://3-tier-web-application-4843-5396-4991/database-config/wp-config.php /var/www/wordpress/

# Set appropriate permissions
sudo chown -R www-data:www-data /var/www/wordpress

# Enable the site (if needed)
sudo a2ensite 000-default

# Final restart to ensure all configurations are applied
sudo service apache2 restart