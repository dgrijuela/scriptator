# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Ubuntu 14.04
  config.vm.box = "ubuntu/trusty64"

  # Don't check for updates when vagrant up
  config.vm.box_check_update = false

  # Port mapping
  config.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true

  # Current folder is synced in /vagrant

  # Default is 300
  config.vm.boot_timeout = 600

  # Amount of RAM
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    #vb.gui = true # To see VirtualBox GUI when there are problems (i.e. connection timeouts)
  end

  # Script to run for provision
  config.vm.provision "shell", path: "provision/ubuntu_base.sh"
  config.vm.provision "shell", path: "provision/ubuntu_rails.sh"
  config.vm.provision "shell", path: "provision/ubuntu_mysql.sh"
end
