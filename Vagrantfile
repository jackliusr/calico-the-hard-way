# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

# Define the number of master and worker nodes
# If this number is changed, remember to update setup-hosts.sh script with the new hosts IP details in /etc/hosts of each VM.
NUM_MASTER_NODE = 1
NUM_WORKER_NODE = 4

IP_NW = "172.16.5."
MASTER_IP_START = 10
NODE_IP_START = 20
LB_IP_START = 30

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  # config.vm.box = "base"
  config.vm.box = "ubuntu/bionic64"
  
  config.vbguest.auto_update = false

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false


  # Provision Master Nodes
  (1..NUM_MASTER_NODE).each do |i|
      config.vm.define "master-#{i}" do |node|
        # Name shown in the GUI
        node.vm.provider "virtualbox" do |vb|
            vb.name = "kubernetes-master-#{i}"
            vb.memory = 2048
            vb.cpus = 2
            vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
            vb.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
            vb.linked_clone = true	
        end
        node.vm.hostname = "master-#{i}"
        node.vm.network :private_network, ip: IP_NW + "#{MASTER_IP_START + i}", virtualbox__intnet: true
        node.vm.network "forwarded_port", guest: 22, host: "#{2710 + i}"
		
        node.vm.provision "setup-hosts", :type => "shell", :path => "ubuntu/vagrant/setup-hosts.sh" do |s|
          s.args = ["enp0s8"]
        end

		node.vm.provision "setup-dns", type: "shell", :path => "ubuntu/update-dns.sh"
		node.vm.provision "install-docker", type: "shell", :path => "ubuntu/install-docker-2.sh"
		node.vm.provision "allow-bridge-nf-traffic", :type => "shell", :path => "ubuntu/allow-bridge-nf-traffic.sh"
		node.vm.provision "file", source: "./ubuntu/cert_verify.sh", destination: "$HOME/"
		node.vm.provision "install-k8s", type: "shell", :path => "ubuntu/install-k8s.sh"

      end
  end

  # Provision Worker Nodes
  (1..NUM_WORKER_NODE).each do |i|
    config.vm.define "worker-#{i}" do |node|
        node.vm.provider "virtualbox" do |vb|
            vb.name = "kubernetes-worker-#{i}"
            vb.memory = 512
            vb.cpus = 1
            vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
            vb.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
            vb.linked_clone = true			
        end
        node.vm.hostname = "worker-#{i}"
        node.vm.network :private_network, ip: IP_NW + "#{NODE_IP_START + i}", virtualbox__intnet: true
		node.vm.network "forwarded_port", guest: 22, host: "#{2720 + i}"

        node.vm.provision "setup-hosts", :type => "shell", :path => "ubuntu/vagrant/setup-hosts.sh" do |s|
          s.args = ["enp0s8"]
        end

        node.vm.provision "setup-dns", type: "shell", :path => "ubuntu/update-dns.sh"
        node.vm.provision "install-docker", type: "shell", :path => "ubuntu/install-docker-2.sh"
        node.vm.provision "allow-bridge-nf-traffic", :type => "shell", :path => "ubuntu/allow-bridge-nf-traffic.sh"
        node.vm.provision "file", source: "./ubuntu/cert_verify.sh", destination: "$HOME/"
		node.vm.provision "install-k8s", type: "shell", :path => "ubuntu/install-k8s.sh"

    end
  end
end
