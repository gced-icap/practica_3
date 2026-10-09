# -*- mode: ruby -*-
# vi: set ft=ruby :

# Modifica la variable STUDENT_PREFIX para sustituir "X" por tu prefijo
# Ejemplo, el alumno Roberto Rey Expósito, que hace la práctica en el curso
# 26/27, utilizará el siguiente prefijo: rre2627
STUDENT_PREFIX = "X"

DEPLOY_CLIENTS = false

# require a Vagrant recent version
Vagrant.require_version ">= 2.4.0"

# Hostnames, IP addresses and resources
SERVER_HOSTNAME    = "#{STUDENT_PREFIX}-server"
CLIENT_HOSTNAME    = "#{STUDENT_PREFIX}-client"
SERVER_IP          = "192.168.100.10"
NUM_CLIENTS        = 2
NUM_DISKS          = 5
DISK_SIZE          = "5GB"
CPU                = 1
MEMORY             = 1024
CPU_EXECUTION_CAP  = 100

require "ipaddr"

Vagrant.configure("2") do |config|
  config.vm.box = "rreye/debian-13"
  config.vm.box_version = "20260304"
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "virtualbox" do |vbox|
    vbox.cpus = CPU
    vbox.memory = MEMORY
    vbox.gui = false
    vbox.linked_clone = false
    vbox.check_guest_additions = false
    vbox.customize ["modifyvm", :id, "--cpuexecutioncap", CPU_EXECUTION_CAP]
  end
    
  # NFS server
  config.vm.define "server", primary: true do |server|
    server.vm.hostname = SERVER_HOSTNAME
    server.vm.network "private_network", ip: SERVER_IP, virtualbox__intnet: true
    
    (1..NUM_DISKS).each do |n|
        server.vm.disk :disk, size: DISK_SIZE, primary: false, name: "disk#{n}"
    end

    server.vm.provider "virtualbox" do |vbox|
	vbox.name = "ICAP-P3-Server"
    end
  end

  # NFS clients
  if DEPLOY_CLIENTS
    current_ip = IPAddr.new(SERVER_IP)

    (1..NUM_CLIENTS).each do |n|
      client_name = "client#{n}"
      current_ip  = current_ip.succ
      client_ip   = current_ip.to_s
    
      config.vm.define client_name do |client|
        client.vm.hostname = "#{CLIENT_HOSTNAME}#{n}"
        client.vm.network "private_network", ip: client_ip, virtualbox__intnet: true
        
        client.vm.provider "virtualbox" do |vbox|
          vbox.name = "ICAP-P3-Client#{n}"
        end
      end
    end
  end

  config.vm.provision "shell", path: "provisioning/bootstrap.sh" do |script|
      script.args = [SERVER_IP, SERVER_HOSTNAME, CLIENT_HOSTNAME, NUM_CLIENTS]
  end
end
