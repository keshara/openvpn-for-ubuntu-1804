#!/bin/bash
main_nic=`ip route | grep default | cut -d ' ' -f 5`
#sed -i s/main_nic/$main_nic/g ufw.rules

if [ `grep -r OPENVPN /etc/ufw/before.rules` ]
then
	echo "its there"
else
	exit 1
fi

