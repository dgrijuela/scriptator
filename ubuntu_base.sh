#!/bin/bash

# Exit script immediately on first error.
set -e 

echo "Adding necessary repositories..."
add-apt-repository ppa:git-core/ppa > /dev/null 2>&1 # last git version

echo "Updating packages list..."
apt-get -qq update # qq is no output except for errors (like >/dev/null)

echo "Installing base packages..."
apt-get -y install curl build-essential libssl-dev libcurl4-gnutls-dev libexpat1-dev wget vim git > /dev/null 2>&1

echo "Editing .bashrc to always arrive at /var/www"
echo "cd /var/www/ >> .bashrc"

echo "Base script completed"
