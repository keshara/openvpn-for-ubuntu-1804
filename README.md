# openvpn-for-ubuntu-1804
Files scripts and configuration for Openvpn setup for ubuntu 18.04

### Getting root privileges
```
# sudo su -
```

### Download the Script and set enough permision on it
```
# cd /root && wget https://raw.githubusercontent.com/keshara/openvpn-for-ubuntu-1804/master/openvpn_install.sh
# chood 777 openvpn_install.sh
```

### Installation
Execute the downloaded script with "ROOT" privileges...
```
# ./openvpn_install.sh
```

Install procedue would ask the UDP port number for which the OpenVPN server should listen on. Make sure set it to the port that you prefer on...
