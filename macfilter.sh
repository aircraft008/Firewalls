#!/bin/sh

#  openwrt  mac filtering

# taken from 
# http://www.unix.com/security/160564-configure-iptables-allows-list-mac-address.html


#1. we need it run postponed - to avoid a potential lockup
#2. 

# iptables -A FORWARD -i eth1 -o eth0 -m mac --mac-source aa:aa:aa:aa:aa:aa -j ACCEPT


for MAC in `cat mac_addresses_file`; do
  iptables -A FORWARD -i eth0 -o eth1 -m mac --mac-source $MAC -j ACCEPT
done

iptables -P FORWARD  DROP



