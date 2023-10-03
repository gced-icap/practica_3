#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Sintaxis: $0 SERVER_IP CLIENT_IP SERVER_HOSTNAME CLIENT_HOSTNAME"
    exit -1
fi

SERVER_IP=$1
CLIENT_IP=$2
SERVER_HOSTNAME=$3
CLIENT_HOSTNAME=$4

apt-get update
# Install basic software
apt-get install -y vim nano sshpass unzip dnsutils dos2unix whois fdisk xfsprogs lvm2 mdadm nfs-kernel-server nfs-common

timedatectl set-timezone Europe/Madrid

# Populate /etc/hosts
sed -i "/server/d" /etc/hosts
sed -i "/client/d" /etc/hosts    
echo -e "$SERVER_IP \t $SERVER_HOSTNAME" >> /etc/hosts
echo -e "$CLIENT_IP \t $CLIENT_HOSTNAME" >> /etc/hosts

# Set $PATH for vagrant
sed -i "/sbin/d" /home/vagrant/.profile
echo 'PATH=/sbin:$PATH' >> /home/vagrant/.profile
