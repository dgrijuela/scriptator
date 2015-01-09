#!/bin/bash

dbrootpass=root
dbname=jobs_development
dbuser=development
dbpass=development
sphinx=true

printf "Installing MySQL and setting it up..."
apt-get -y install libmysqlclient-dev > /dev/null 2>&1
debconf-set-selections <<< "mysql-server mysql-server/root_password password $dbrootpass"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $dbrootpass"
apt-get -y install mysql-server > /dev/null 2>&1

printf "Creating MySQL user '$dbuser' with pass '$dbpass' and access to database '$dbname'..."
mysql -uroot -p$dbrootpass <<SQL
CREATE USER '$dbuser'@localhost IDENTIFIED BY '$dbpass';
CREATE DATABASE $dbname;
GRANT ALL PRIVILEGES ON $dbname.* to $dbuser@'%' IDENTIFIED BY '$dbpass';
GRANT ALL PRIVILEGES ON $dbname.* to $dbuser@'localhost' IDENTIFIED BY '$dbpass' ;
FLUSH PRIVILEGES;
SQL

if [ "$sphinx" = true ] ; then
  printf "Installing Sphinx..."
  apt-get -y install python-sphinx sphinxsearch > /dev/null 2>&1
fi

printf "MySQL script completed"
