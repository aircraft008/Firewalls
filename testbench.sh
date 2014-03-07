#!/bin/sh

IFACE=$1
#           for the bridged firewall: br-lan

A=`ifconfig $IFACE | grep -A 1 $IFACE | tail -1 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ` 

MYIP=`echo $A | awk -F" " '{print $1}'`

MYMask=`echo $A | awk -F" " '{print $NF}'`
MYMask="255.255.255.0" 

echo IP=$MYIP and MASK=$MYMask
 



#---------- trying to sort by vlan ------------------ locks
# this locks up.....
#       $IPTABLES -A FORWARD -m physdev --physdev-in eth0.2  -j  ACCEPT
#       $IPTABLES -A FORWARD -m physdev --physdev-in eth0.1  -j  ACCEPT



#-------------------------asterisk----------------------------
#opkg update
#opkg install asterisk18
#http://wiki.openwrt.org/doc/howto/voip.asterisk
