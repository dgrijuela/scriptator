#!/bin/bash

# This script will fully prepare an Ubuntu computer for web development (and more)

# Variables
tmp_path=/tmp
vagranturl=https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.1_x86_64.deb # FIXME
vagrant=vagrant_1.7.1_x86_64.deb # FIXME

# Exit script immediately on first error.
set -e 

echo "Changing DNS to Google's ones..."
echo "nameserver 8.8.8.8 > /etc/resolv.conf" # single > deletes everything and appends
echo "nameserver 8.8.4.4 >> /etc/resolv.conf" # double >> appends at the end

echo "Removing default shit..."
apt-get -y purge thunderbird nautilus-sendto empathy
apt-get -y autoremove
apt-get -y autoclean

echo "Adding necessary repositories..."
add-apt-repository -y ppa:git-core/ppa # last git version
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - # google key
curl -sL https://deb.nodesource.com/setup | sudo bash - # node repo
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' # chrome repo
apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E # mit key
add-apt-repository -y "deb http://linux.dropbox.com/ubuntu $(lsb_release -cs) main" # dropbox repo

echo "Remember to do apt-get update (it fails sometimes)..."
#apt-get update

echo "Installing base packages..."
apt-get -y install curl build-essential python python-dev cmake libssl-dev libcurl4-gnutls-dev libexpat1-dev wget vim git whois

echo "Installing Terminator (great console)..."
apt-get install -y terminator

echo "Installing Compiz to awesome window management..."
apt-get install -y compiz compiz-plugins compizconfig-settings-manager

echo "Installing node.js and npm..."
apt-get -y install nodejs
npm install npm -g

echo "Installing RVM with Ruby version $ruby and last version of Ruby Gems..."
curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -  # This is for signature verification
curl -sSL https://get.rvm.io | bash -s stable --ruby
source /usr/local/rvm/scripts/rvm
rvm use $ruby

echo "Installing Rails version $rails..."
gem install rails --no-document

echo "Installing MySQL and its settings..."
echo "mysql-server mysql-server/root_password password $mysqlrootpass" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $mysqlrootpass" | debconf-set-selections
apt-get -y install mysql-server

echo "Installing PostgreSQL..."
apt-get install postgresql

echo "Installing Virtualbox..."
apt-get install dkms # dependency
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add - # Oracle public key
sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian trusty contrib" >> /etc/apt/sources.list.d/virtualbox.list' # Add the ppa
apt-get install virtualbox-4.3

echo "Installing Vagrant..."
wget $vagranturl && dpkg -i $vagrant
rm $vagrant

echo "Installing Gimp..."
apt-get install gimp

echo "Installing Chrome..."
apt-get install google-chrome-stable

echo "Installing Dropbox..."
apt-get install dropbox

echo "Creating a key to add to Github, Bitbutcket, etc"
sudo -u ${LOGNAME} ssh-keygen -t rsa -C "$email" # create them in non-root path
eval "$(ssh-agent -s)"
sudo -u ${LOGNAME} ssh-add ~/.ssh/id_rsa
apt-get install xclip # to copy to clipboard
sudo -u ${LOGNAME} xclip -sel clip < ~/.ssh/id_rsa.pub
echo "Now the key is in your clipboard, go and paste it in you github/bitbucket account!"

echo "You're ready my sir"
