#!/bin/bash

ubuntu_ver=`cat /etc/os-release  | grep VERSION_ID | egrep \".*\" | cut -d \" -f2`

if [ $ubuntu_ver == "18.04" ]
then 
	echo -e "\nDetected the ubuntu version as $ubuntu_ver\n"
	echo -e "adding \"ondrej/php repository\"\n"
	add-apt-repository -y ppa:ondrej/php
	echo -e  "installing openvpn & its dependancies...\n"
	apt-get update && apt-get -y install openvpn git
else	echo "This script is not supported on your current ubuntu $ubuntu_ver version"
fi

mkdir /root/git && cd /root/git/
echo -e "\ncloning the git repo...\n"
git clone https://github.com/keshara/openvpn-for-ubuntu-1804.git
echo -e "\ncoping the downloaded files into /etc/openvpn/ dir...\n"
cp -rf /root/git/openvpn-for-ubuntu-1804/server.conf /etc/openvpn/
cp -rf /root/git/openvpn-for-ubuntu-1804/scripts /etc/openvpn/
echo -e "\nCleaning off the downloaded files...\n"
rm -fr /root/git
