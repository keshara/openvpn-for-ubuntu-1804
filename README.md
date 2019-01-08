# OpenVPN Server for Ubuntu 1804
This provides all the files and proceedure to setup Openvpn server on Ubuntu 18.04. Installation and Setting up nessecery configuration is automated within the Script.

### Getting root privileges
```
# sudo su -
```

### Download the Script and set enough permision on it
```
# cd /root && wget https://raw.githubusercontent.com/keshara/openvpn-for-ubuntu-1804/master/openvpn_install.sh
# chmod 777 openvpn_install.sh
```

### Installation
Execute the downloaded script with "ROOT" privileges...
```
# ./openvpn_install.sh
```

Install procedue would ask the UDP port number for which the OpenVPN server should listen on. Make sure to set it to the port that you prefer on...
