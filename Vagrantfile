# -*- mode: ruby -*-
# vi: set ft=ruby :

# Modifica la variable STUDENT_PREFIX para sustituir "xxx" por tu prefijo
# Ejemplo, el alumno Roberto Rey Expósito, que hace la práctica en el curso
# 23/24, utilizará el siguiente prefijo: rre2324
STUDENT_PREFIX="rre2324"

# require a Vagrant recent version
Vagrant.require_version ">= 2.3.0"

# Hostnames and IP addresses
SERVER_HOSTNAME = "#{STUDENT_PREFIX}-server"
CLIENT_HOSTNAME = "#{STUDENT_PREFIX}-client"
SERVER_IP="192.168.100.10"
CLIENT_IP="192.168.100.11"

Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.vm.box_version = "12.20230723.1"
  config.vm.box_check_update = false
  config.vbguest.auto_update = false

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

        for i in 0..3 do
            filename = "disks/disk#{i}.vdi"
            unless File.exist?(filename)
                prov.customize ["createmedium", "disk", "--filename", filename, "--format", "vdi", "--size", 5 * 1024]
            end
            prov.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", i + 1, "--device", 0, "--type", "hdd", "--medium", filename]
        end
    end
  end
  
  # NFS client
  config.vm.define "client" do |client|
    client.vm.hostname = CLIENT_HOSTNAME
    client.vm.network "private_network", ip: "#{CLIENT_IP}", virtualbox__intnet: true
        
    client.vm.provider "virtualbox" do |prov|
	prov.name = "ICAP-P3-Client"
        prov.cpus = 1
        prov.memory = 1024
	prov.gui = false
	prov.linked_clone = false
    end
  end

  config.vm.provision "shell", path: "provisioning/bootstrap.sh" do |script|
      script.args = [SERVER_IP, CLIENT_IP, SERVER_HOSTNAME, CLIENT_HOSTNAME]
  end
end
