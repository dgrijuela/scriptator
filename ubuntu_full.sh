#!/bin/bash

# This script will fully prepare an Ubuntu computer for web development

# Variables
dbname=jobs_development
dbname2=jobs_testing
dbuser=development
dbpass=development
ruby=2.2.0
rails=4.2
vagranturl=https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.1_x86_64.deb
vagrant=vagrant_1.7.1_x86_64.deb

# Exit script immediately on first error.
set -e 

echo "Changing DNS to Google's ones..."
: > /etc/resolv.conf # this is to remove existing nameservers
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" > /etc/resolv.conf

echo "Adding necessary repositories..."
add-apt-repository ppa:git-core/ppa > /dev/null 2>&1 # last git version

echo "Updating packages list..."
apt-get -qq update # qq is no output except for errors (like >/dev/null)

echo "Installing base packages..."
apt-get -y install curl build-essential libssl-dev libcurl4-gnutls-dev libexpat1-dev wget vim git whois > /dev/null 2>&1

echo "Installing node.js and npm..."
curl -sL https://deb.nodesource.com/setup | sudo bash - > /dev/null 2>&1
apt-get -y install nodejs > /dev/null 2>&1
npm install npm -g > /dev/null 2>&1

echo "Installing RVM with Ruby version $ruby and last version of Ruby Gems..."
command curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -  > /dev/null 2>&1 # This is for signature verification
curl -sSL https://get.rvm.io | bash -s stable --ruby=$ruby > /dev/null 2>&1
source /usr/local/rvm/scripts/rvm > /dev/null 2>&1
rvm use $ruby

echo "Installing Rails version $rails..."
gem install rails -v $rails --no-document > /dev/null 2>&1

echo "Installing MySQL and its settings..."
echo "mysql-server mysql-server/root_password password $dbpass" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $dbpass" | debconf-set-selections
apt-get -y install mysql-server mysql-client > /dev/null 2>&1

echo "Creating MySQL database '$dbname' and user '$dbuser' with pass '$dbpass' and access to it..."
mysql -uroot -proot <<SQL
CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';
CREATE DATABASE $dbname;
CREATE DATABASE $dbname2;
GRANT ALL PRIVILEGES ON $dbname* to '$dbuser'@'localhost';
GRANT ALL PRIVILEGES ON $dbname2* to '$dbuser'@'localhost';
FLUSH PRIVILEGES;
SQL

echo "Installing Virtualbox..."
apt-get install dkms # dependency
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add - # Oracle public key
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian trusty contrib" >> /etc/apt/sources.list.d/virtualbox.list' # Add the ppa
apt-get install virtualbox-4.3

echo "Installing Vagrant..."
wget $vagranturl && dpkg -i $vagrant

echo "Installing Meteor..."
curl https://install.meteor.com/ | sh

echo "Creating a key to add to Github, Bitbutcket, etc"
sudo -u ${LOGNAME} ssh-keygen -t rsa -C "$email" # create them in non-root path
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
apt-get install xclip # to copy to clipboard
sudo -u ${LOGNAME} xclip -sel clip < ~/.ssh/id_rsa.pub
echo "Now the key is in your clipboard, go and paste it!"
