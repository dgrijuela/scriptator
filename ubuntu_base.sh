#!/bin/bash

printf "Adding necessary repositories..."
add-apt-repository ppa:git-core/ppa > /dev/null 2>&1 # last git version

printf "Updating packages list..."
apt-get -qq update # qq is no output except for errors (like >/dev/null)

printf "Installing base packages..."
apt-get -y install curl build-essential libssl-dev libcurl4-gnutls-dev libexpat1-dev wget git > /dev/null 2>&1

printf "Editing .bashrc to always arrive at /vagrant/..."
echo "cd /vagrant/" >> /home/vagrant/.bashrc

printf "Base script completed"
