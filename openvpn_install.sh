#!/bin/bash

ubuntu_ver=`cat /etc/os-release  | grep VERSION_ID | egrep \".*\" | cut -d \" -f2`
main_nic=`ip route | grep default | cut -d ' ' -f 5`

if [ $ubuntu_ver == "18.04" ]
then 
	echo -e "\nDetected the ubuntu version as $ubuntu_ver\n"
	echo -e "Adding \"ondrej/php repository\"\n"
	add-apt-repository -y ppa:ondrej/php
	echo -e  "\nInstalling openvpn & its dependancies...\n"
	apt-get update && apt-get -y install openvpn git
else	echo "This script is not supported on your current ubuntu $ubuntu_ver version"
fi

mkdir /root/git && cd /root/git/
echo -e "\ncloning the git repo...\n"
git clone https://github.com/keshara/openvpn-for-ubuntu-1804.git

echo -e "\ncoping the downloaded files into /etc/openvpn/ dir...\n"
cp -rf /root/git/openvpn-for-ubuntu-1804/server.conf /etc/openvpn/
cp -rf /root/git/openvpn-for-ubuntu-1804/scripts /etc/openvpn/

# Setting environment as the user INPUTS
### Server Port?
echo -e "On which UDP Port that the OpenVPN-Server should run on?"
read -p 'UDP_PORT: press enter to have default[1194] => ' SRV_PORT
sed -i s/port\ [0-9].*/port\ $SRV_PORT/g /etc/openvpn/server.conf

# ipv4 routing
echo -e "Working on IPV4 Routing...\n"
cp -rf /root/git/openvpn-for-ubuntu-1804/60-ipv4-forward.conf /etc/sysctl.d/
sysctl -p

# firewall rules via ufw
echo -e "Working on UFW rules...\n"
sed -i s/main_nic/$main_nic/g /root/git/openvpn-for-ubuntu-1804/ufw.rules
cat /root/git/openvpn-for-ubuntu-1804/ufw.rules | cat - /etc/ufw/before.rules > temp && mv temp /etc/ufw/before.rules

echo -e "Cleaning off the downloaded files...\n"
rm -fr /root/git

