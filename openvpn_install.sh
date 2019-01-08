#!/bin/bash

ubuntu_ver=`cat /etc/os-release  | grep VERSION_ID | egrep \".*\" | cut -d \" -f2`
main_nic=`ip route | grep default | cut -d ' ' -f 5`

if [ $ubuntu_ver == "18.04" ]
then 
	echo -e "\nDetected the ubuntu version as $ubuntu_ver\n"
	sleep 1
	echo -e "Adding \"ondrej/php repository\"\n"
	add-apt-repository -y ppa:ondrej/php
	echo -e  "\nInstalling openvpn & its dependancies...\n"
	apt-get update && apt-get -y install php7.2 php7.2-cli php7.2-gd php7.2-mysql php7.2-common php7.2-mbstring php7.2-bcmath php7.2-xml php7.2-fpm php7.2-curl php7.2-zip  curl mysql-client-core-5.7 mysql-common openvpn git
else	echo "This script is not supported on your current ubuntu $ubuntu_ver version"
fi

mkdir /root/git && cd /root/git/
echo -e "\ncloning the git repo...\n"
sleep 1
git clone https://github.com/keshara/openvpn-for-ubuntu-1804.git

echo -e "\ncoping the downloaded files into /etc/openvpn/ dir...\n"
sleep 1
cp -rf /root/git/openvpn-for-ubuntu-1804/server.conf /etc/openvpn/
cp -rf /root/git/openvpn-for-ubuntu-1804/scripts /etc/openvpn/
cp -rf /root/git/openvpn-for-ubuntu-1804/certs /etc/openvpn/

# Setting environment as the user INPUTS
### Server Port?
echo -e "On which UDP Port that the OpenVPN-Server should run on?"
sleep 1
read -e -p 'UDP_PORT: [default] => ' -i "1194" SRV_PORT
sed -i s/port\ [0-9].*/port\ $SRV_PORT/g /etc/openvpn/server.conf

# ipv4 routing
echo -e "Working on IPV4 Routing...\n"
sleep 1
cp -rf /root/git/openvpn-for-ubuntu-1804/60-ipv4-forward.conf /etc/sysctl.d/
sysctl -p /etc/sysctl.d/60-ipv4-forward.conf

# firewall rules via ufw
echo -e "\nWorking on UFW rules...\n"
sleep 1
sed -i s/main_nic/$main_nic/g /root/git/openvpn-for-ubuntu-1804/ufw.rules

if [ `grep -r OPENVPN /etc/ufw/before.rules` ]
    then
	cat /root/git/openvpn-for-ubuntu-1804/ufw.rules | cat - /etc/ufw/before.rules > temp && mv temp /etc/ufw/before.rules
    else
	echo "Corrent firewall rule already applied"
fi

sed -i s/DEFAULT_FORWARD_POLICY\=\"DROP\"/DEFAULT_FORWARD_POLICY\=\"ACCEPT\"/g /etc/default/ufw
echo -e "\nAdding Firewall ACCEPT on $SRV_PORT/udp...\n"
sleep 2
ufw allow $SRV_PORT/udp
echo -e "\nAdding Firewall ACCEPT on SSH/Service...\n"
sleep 2
ufw allow OpenSSH
ufw disable
echo "y" | sudo ufw enable

# remove the download files
echo -e "Cleaning off the downloaded files...\n"
sleep 1
rm -fr /root/git

# starting up the service
echo -e "Starting the OpenVPN service...\n"
systemctl start openvpn@server.service
