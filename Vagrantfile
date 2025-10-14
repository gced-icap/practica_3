# -*- mode: ruby -*-
# vi: set ft=ruby :

# Modifica la variable STUDENT_PREFIX para sustituir "X" por tu prefijo
# Ejemplo, el alumno Roberto Rey Expósito, que hace la práctica en el curso
# 25/26, utilizará el siguiente prefijo: rre2526
STUDENT_PREFIX="X"

DEPLOY_CLIENTS=false

# require a Vagrant recent version
Vagrant.require_version ">= 2.4.0"

# Hostnames and IP addresses
SERVER_HOSTNAME = "#{STUDENT_PREFIX}-server"
CLIENT_HOSTNAME = "#{STUDENT_PREFIX}-client"
SERVER_IP="192.168.100.10"
NUM_CLIENTS=2

require "ipaddr"
CLIENT_IP_ADDR = IPAddr.new(SERVER_IP)

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.box_version = "202508.03.0"
  config.vm.box_check_update = false
  config.vbguest.auto_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # NFS server
  config.vm.define "server", primary: true do |server|
    server.vm.hostname = SERVER_HOSTNAME
    server.vm.network "private_network", ip: "#{SERVER_IP}", virtualbox__intnet: true

    server.vm.provider "virtualbox" do |prov|
	      prov.name = "ICAP-P3-Server"
        prov.cpus = 1
        prov.memory = 1024
	      prov.gui = false
	      prov.linked_clone = false

        for i in 0..4 do
            filename = "disks/disk#{i}.vdi"
            unless File.exist?(filename)
                prov.customize ["createmedium", "disk", "--filename", filename, "--format", "vdi", "--size", 5 * 1024]
            end
            prov.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", i + 1, "--device", 0, "--type", "hdd", "--medium", filename]
        end
    end
  end

  # NFS clients
  if DEPLOY_CLIENTS
    (1..NUM_CLIENTS).each do |n|
      NAME = "client#{n}"
      CLIENT_IP_ADDR = CLIENT_IP_ADDR.succ
      ip_addr = CLIENT_IP_ADDR.to_s
    
      config.vm.define NAME do |client|
        client.vm.hostname = "#{CLIENT_HOSTNAME}#{n}"
        client.vm.network "private_network", ip: ip_addr, virtualbox__intnet: true
        
        client.vm.provider "virtualbox" do |prov|
          prov.name = "ICAP-P3-Client#{n}"
          prov.cpus = 1
          prov.memory = 1024
	        prov.gui = false
	        prov.linked_clone = false
        end
      end
    end
  end

  config.vm.provision "shell", path: "provisioning/bootstrap.sh" do |script|
      script.args = [SERVER_IP, SERVER_HOSTNAME, CLIENT_HOSTNAME, NUM_CLIENTS]
  end
end
