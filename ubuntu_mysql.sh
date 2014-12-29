#!/bin/bash

dbrootpass=162543
dbname=jobs_development
dbname2=jobs_testing
dbuser=development
dbpass=development

set -e 

printf "Installing MySQL and its settings"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $dbrootpass"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $dbrootpass"
apt-get -y install mysql-server > /dev/null 2>&1

printf "Creating MySQL user '$dbuser' with pass '$dbpass' and access to database '$dbname'"
mysql -uroot -p$dbrootpass <<SQL
CREATE USER '$dbuser' IDENTIFIED BY '$dbpass';
CREATE DATABASE $dbname;
CREATE DATABASE $dbname2;
GRANT ALL PRIVILEGES ON $dbname.* to '$dbuser'@'localhost';
GRANT ALL PRIVILEGES ON $dbname2.* to '$dbuser'@'localhost';
FLUSH PRIVILEGES;
SQL

printf "MySQL script completed"
