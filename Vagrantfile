# -*- mode: ruby -*-
# vi: set ft=ruby :

SERVER_IP="192.168.100.10"
CLIENT_IP="192.168.100.11"

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  config.vm.box_check_update = false
  config.vbguest.auto_update = false

  config.vm.define "server", primary: true do |server|
    server.vm.hostname = "server"
    server.vm.network :private_network, ip: "#{SERVER_IP}"

    server.vm.provider :virtualbox do |prov|
	prov.name = "ICAP-P3-Server"
        prov.cpus = 1
        prov.memory = 1024
	prov.linked_clone = true

        for i in 0..3 do
            filename = "disks/disk#{i}.vdi"
            unless File.exist?(filename)
                prov.customize ["createmedium", "disk", "--filename", filename, "--format", "vdi", "--size", 5 * 1024]
            end
            prov.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", i + 1, "--device", 0, "--type", "hdd", "--medium", filename]
        end
    end
  end
  
  config.vm.define "client" do |client|
    client.vm.hostname = "client"
    client.vm.network :private_network, ip: "#{CLIENT_IP}"
        
    client.vm.provider :virtualbox do |prov|
	prov.name = "ICAP-P3-Client"
        prov.cpus = 1
        prov.memory = 1024
	prov.linked_clone = true
    end
  end

  config.vm.provision "shell", path: "provisioning/bootstrap.sh" do |script|
      script.args = [SERVER_IP, CLIENT_IP]
  end

end
