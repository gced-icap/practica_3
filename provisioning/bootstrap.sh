#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Sintaxis: $0 SERVER_IP CLIENT_IP"
    exit
fi

SERVER_IP=$1
CLIENT_IP=$2

apt-get update
# Install basic software
apt-get install -y vim nano sshpass unzip dnsutils dos2unix whois lvm2 mdadm nfs-kernel-server nfs-common

timedatectl set-timezone Europe/Madrid

# Populate /etc/hosts
sed -i "/server/d" /etc/hosts
sed -i "/client/d" /etc/hosts
    
if ! grep -Fq $SERVER_IP /etc/hosts ; then
        echo -e "$SERVER_IP \t server" >> /etc/hosts
fi

if ! grep -Fq $CLIENT_IP /etc/hosts ; then
        echo -e "$CLIENT_IP \t client" >> /etc/hosts
fi
