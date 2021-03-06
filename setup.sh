#!/usr/bin/env bash

# Upgrade Base Packages
sudo apt-get update
sudo apt-get upgrade -y

# Install Web Packages
sudo apt-get install -y build-essential dkms re2c apache2 php5 php5-dev php-pear php5-xdebug php5-apcu php5-json php5-sqlite \
php5-mysql php5-pgsql php5-gd curl php5-curl memcached php5-memcached libmcrypt4 php5-mcrypt redis-server beanstalkd \
openssh-server git vim python2.7-dev

# Download Bash Aliases
wget -O ~/.bash_aliases https://raw2.github.com/DeSlaper/virtualbox/master/aliases

# Set Apache ServerName
sudo sed -i "s/#ServerRoot.*/ServerName develop/" /etc/apache2/apache2.conf
sudo /etc/init.d/apache2 restart

# Install MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server

# Configure MySQL
sudo sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 10.0.2.15/' /etc/mysql/my.cnf
mysql -u root -p mysql -e "GRANT ALL ON *.* TO root@'192.168.1.64' IDENTIFIED BY 'root';"
sudo service mysql restart

# Configure Mcrypt (Ubuntu 13.10)
sudo ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available
sudo php5enmod mcrypt
sudo service apache2 restart

# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Install PHPUnit
sudo pear config-set auto_discover 1
sudo pear install pear.phpunit.de/phpunit

# Install Mailparse (For Snappy)
sudo pecl install mailparse

# get phpini
sudo wget -O /etc/php5/apache2/php.ini https://raw2.github.com/DeSlaper/virtualbox/master/php.ini

# Generate SSH Key
cd ~
mkdir .ssh
cd ~/.ssh
ssh-keygen -f id_rsa -t rsa -N ''

# Install Git Subtree
cd ~
git clone https://github.com/apenwarr/git-subtree
cd ~/git-subtree
sudo sh install.sh
cd ~
rm -rf git-subtree/

# Install Git Subsplit
git clone https://github.com/dflydev/git-subsplit
cd ~/git-subsplit
sudo sh install.sh
cd ~
rm -rf git-subsplit/

# Configure & Start Beanstalkd Queue
sudo sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
sudo /etc/init.d/beanstalkd start

# Install Fabric & Hipchat Plugin
sudo apt-get install -y python-pip
sudo pip install fabric
sudo pip install python-simple-hipchat

# Install NodeJs
cd ~
wget http://nodejs.org/dist/v0.10.24/node-v0.10.24.tar.gz
tar -xvf node-v0.10.24.tar.gz
cd node-v0.10.24
./configure
make
sudo make install
cd ~
rm ~/node-v0.10.24.tar.gz
rm -rf ~/node-v0.10.24

# Install Grunt
sudo npm install -g grunt-cli

# Install Forever
sudo npm install -g forever

# Create Scripts Directory
mkdir ~/Scripts
mkdir ~/Scripts/PhpInfo

# Download Serve Script
cd ~/Scripts
wget https://raw2.github.com/DeSlaper/virtualbox/master/serve.sh

# Download Release Scripts
cd ~/Scripts
wget https://raw2.github.com/DeSlaper/virtualbox/master/release-scripts/illuminate-split-full.sh
wget https://raw2.github.com/DeSlaper/virtualbox/master/release-scripts/illuminate-split-heads.sh
wget https://raw2.github.com/DeSlaper/virtualbox/master/release-scripts/illuminate-split-tags.sh
wget https://raw2.github.com/DeSlaper/virtualbox/master/release-scripts/illuminate-split-single.sh

# Build PHP Info Site
echo "<?php phpinfo();" > ~/Scripts/PhpInfo/index.php

# Configure Apache Hosts
sudo a2enmod rewrite
echo "127.0.0.1  info.app" | sudo tee -a /etc/hosts
vhost="<VirtualHost *:80>
     ServerName info.app
     DocumentRoot /home/develop/Scripts/PhpInfo
     <Directory \"/home/develop/Scripts/PhpInfo\">
          Order allow,deny
          Allow from all
          Require all granted
          AllowOverride All
    </Directory>
</VirtualHost>"
echo "$vhost" | sudo tee /etc/apache2/sites-available/info.app.conf
sudo a2ensite info.app
sudo /etc/init.d/apache2 restart

# Install Beanstalkd Console
cd ~/Scripts
git clone https://github.com/ptrofimov/beanstalk_console.git Beansole
vhost="<VirtualHost *:80>
     ServerName beansole.app
     DocumentRoot /home/develop/Scripts/Beansole/public
     <Directory \"/home/develop/Scripts/Beansole/public\">
          Order allow,deny
          Allow from all
          Require all granted
          AllowOverride All
    </Directory>
</VirtualHost>"
echo "$vhost" | sudo tee /etc/apache2/sites-available/beansole.app.conf
sudo a2ensite beansole.app
sudo /etc/init.d/apache2 restart

# VirtualBox Guest Additions
sudo /etc/init.d/vboxadd setup
sudo mount /dev/cdrom /media/cdrom
sudo sh /media/cdrom/VBoxLinuxAdditions.run
sudo adduser develop vboxsf
sudo adduser develop vboxsf
sudo usermod -aG vboxsf www-data
sudo usermod -aG vboxsf develop

# Final Clean
cd ~
rm -rf tmp/

# Reboot
sudo reboot
