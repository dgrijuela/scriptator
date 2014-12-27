#!/bin/bash

# Variables
dbname=jobs_development
dbname2=jobs_testing
dbuser=development
dbpass=development


# Exit script immediately on first error.
set -e 

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
