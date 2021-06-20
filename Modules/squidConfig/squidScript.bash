#sudo apt install squid

#https://www.linuxhelp.com/how-to-install-and-configure-squid-proxy-in-ubuntu-20-4-1#:~:text=%20Install%20Squid%3A%20%201%20To%20install%20Squid,on%20Ubuntu%20comes%20to%20end..%20%20More%20

#####transfer files using BITVISE SFTP##############################

#echo "foo" | sudo tee /etc/my.cfg # Overwrite: Equivalent of echo "foo" > /etc/my.cnf
#echo "foo" | sudo tee -a /etc/my.cfg # Append: Equivalent of echo "foo" >> /etc/my.cnf


#!/bin/sh

echo "install squid using yum -y install squid"

yum -y install squid

# open firewall port
firewall-cmd --add-port=3128/tcp --permanent
systemctl restart firewalld
# iptables -t filter --list

CHECKSQUID=$(systemctl | grep squid | grep running)

if [ ! -z "$CHECKSQUID" ]
then
    echo "Squid already running. will stop it. systemctl stop squid"
    systemctl stop squid
fi

echo "Copy squid.conf file to /etc/squid/squid.conf"
\cp squid.conf /etc/squid/squid.conf

echo "Copy *.txt file to /etc/squid/"
\cp *.txt /etc/squid

echo "find /etc/squid/ -type f -name *.txt -print  | xargs -I {} chgrp squid {}"
find /etc/squid -type f -name "*.txt" -print  | xargs -I {} chgrp squid {}


# rm -f squid.conf
# rm -f whitelist.txt

CHECKSQUID1=$(systemctl | grep squid )

if [ -z "$CHECKSQUID1" ]
then
    echo "systemctl enable squid"

    systemctl enable squid
fi

echo "systemctl start squid"

systemctl start squid

echo "systemctl status squid"

systemctl status squid