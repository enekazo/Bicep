#!/bin/sh

echo "install squid using yum -y install squid"

#yum -y install squid

# open firewall port
#firewall-cmd --add-port=3128/tcp --permanent
#systemctl restart firewalld
# iptables -t filter --list

sudo apt update
sudo apt install squid