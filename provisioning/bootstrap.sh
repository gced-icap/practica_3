#!/bin/bash

if [[ "$#" -ne 4 ]]; then
    echo "Sintaxis: $0 SERVER_IP SERVER_HOSTNAME CLIENT_HOSTNAME NUM_CLIENTS"
    exit 1
fi

SERVER_IP=$1
SERVER_HOSTNAME=$2
CLIENT_HOSTNAME=$3
NUM_CLIENTS=$4

export DEBIAN_FRONTEND=noninteractive

# Install basic software
apt-get clean all
apt-get update
SOFTWARE="vim nano openssh-server sshpass unzip dnsutils dos2unix whois fdisk xfsprogs lvm2 mdadm nfs-kernel-server nfs-common"
echo "==> Installing software packages..."
if ! apt-get install -y -qq $SOFTWARE > /tmp/apt.log 2>&1; then
    echo "Error when installing software, log:"
    cat /tmp/apt.log
    exit 1
fi
echo "==> done"

timedatectl set-timezone Europe/Madrid
passwd -d root
echo 'root:vagrant' | chpasswd -m
passwd -d vagrant
echo 'vagrant:vagrant' | chpasswd -m

# Populate /etc/hosts
sed -i "/server/d" /etc/hosts
sed -i "/client/d" /etc/hosts
echo -e "$SERVER_IP \t $SERVER_HOSTNAME" >> /etc/hosts
IP_PREFIX=$(echo "$SERVER_IP" | cut -d. -f1-3)
IP_LAST=$(echo "$SERVER_IP" | cut -d. -f4)
for (( i=1; i<=$NUM_CLIENTS; i++ )); do
    client_ip="$IP_PREFIX.$((IP_LAST + i))"
    echo -e "${client_ip} \t ${CLIENT_HOSTNAME}${i}" >> /etc/hosts
done


# SSH config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config
sed -i 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#KbdInteractiveAuthentication/KbdInteractiveAuthentication/' /etc/ssh/sshd_config
systemctl restart ssh

# .profile
sed -i "/sbin/d" /home/vagrant/.profile
echo 'PATH=/sbin:$PATH' >> /home/vagrant/.profile

if [[ "$(hostname)" = "$SERVER_HOSTNAME" ]]; then
    SCRIPT=/home/vagrant/fileGen.sh
    echo "Downloading fileGen.sh script..."
    wget -q -O $SCRIPT https://gac.udc.es/~rober/icap/fileGen.sh
    if [[ $? -ne 0 ]]; then
        echo "Error: download failed!"
        exit 1
    fi
    if [[ ! -f $SCRIPT ]]; then
        echo "Error: script not found!"
        exit 1
    fi
    chmod +x $SCRIPT
    chown vagrant:vagrant $SCRIPT
fi
