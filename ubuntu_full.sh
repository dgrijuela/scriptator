#!/bin/bash

# Exit script immediately on first error.
set -e 

echo "Adding necessary repositories..."
add-apt-repository ppa:git-core/ppa > /dev/null 2>&1 # Last git version

echo "Updating packages list..."
apt-get -qq update # qq is no output except for errors (like >/dev/null)

echo "Installing base packages..."
apt-get -y install curl build-essential libssl-dev libcurl4-gnutls-dev libexpat1-dev wget vim git > /dev/null 2>&1

echo "Installing node.js and npm..."
curl -sL https://deb.nodesource.com/setup | sudo bash - > /dev/null 2>&1
apt-get -y install nodejs > /dev/null 2>&1
npm install npm -g > /dev/null 2>&1

echo "Installing RVM with Ruby version $RUBY and last version of Ruby Gems..."
command curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -  > /dev/null 2>&1 # This is for signature verification
curl -sSL https://get.rvm.io | bash -s stable --ruby=$RUBY > /dev/null 2>&1
source /usr/local/rvm/scripts/rvm > /dev/null 2>&1
gem update --system --no-document

echo "Installing Rails version $RAILS..."
gem install rails -v $RAILS --no-document > /dev/null 2>&1

echo "Installing MySQL and its settings..."
echo "mysql-server mysql-server/root_password password $DBPASS" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBPASS" | debconf-set-selections
apt-get -y install mysql-server mysql-client > /dev/null 2>&1

echo "Creating MySQL database '$DBNAME' and user '$DBUSER' with pass '$DBPASS' and access to it..."
mysql -uroot -proot <<SQL
CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS';
CREATE DATABASE $DBNAME;
CREATE DATABASE $DBNAME2;
GRANT ALL PRIVILEGES ON $DBNAME* to '$DBUSER'@'localhost';
GRANT ALL PRIVILEGES ON $DBNAME2* to '$DBUSER'@'localhost';
FLUSH PRIVILEGES;
SQL
