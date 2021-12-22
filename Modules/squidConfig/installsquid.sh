#!/bin/sh

echo "install squid using yum -y install squid"

#yum -y install squid

# open firewall port
#firewall-cmd --add-port=3128/tcp --permanent
#systemctl restart firewalld
# iptables -t filter --list

sudo apt-get update
#sudo apt-get install squid

#sudo systemctl stop squid

#echo "Copy squid.conf file to /etc/squid/squid.conf"
#\cp squid.conf /etc/squid/squid.conf

#echo "Copy *.txt file to /etc/squid/"
#\cp *.txt /etc/squid

#systemctl start squid