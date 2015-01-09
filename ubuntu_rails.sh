#!/bin/bash

ruby=2.2.0
rails=4.2

printf "Installing node.js and npm..."
curl -sL https://deb.nodesource.com/setup | sudo bash - > /dev/null 2>&1
apt-get -y install nodejs > /dev/null 2>&1
npm install npm -g > /dev/null 2>&1

printf "Installing RVM with Ruby $ruby and latest Ruby Gems..."
curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -  > /dev/null 2>&1 # This is for signature verification
curl -sSL https://get.rvm.io | bash -s stable --ruby=$ruby > /dev/null 2>&1
source /usr/local/rvm/scripts/rvm > /dev/null 2>&1
gem update --system --no-document
gem update --no-document

printf "Installing Rails $rails..."
gem install rails -v $rails --no-document > /dev/null 2>&1

printf "Rails script completed"
