#!/bin/bash

# Variables
ruby=2.15
rails=4.2

# Exit script immediately on first error.
set -e 

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

echo "Rails script completed"
