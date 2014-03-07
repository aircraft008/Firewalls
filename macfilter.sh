#!/bin/sh
 #!/bin/sh /etc/rc.common
 # Customized iptables script for OpenWrt 10.03

#  openwrt  mac filtering
#        taken from 
# http://www.unix.com/security/160564-configure-iptables-allows-list-mac-address.html

#1. we need it run postponed - to avoid a potential lockup
#2. we like to have it as a service

START=46

IPTABLES=/usr/sbin/iptables
GREP=/bin/grep
TAIL=/usr/bin/tail
AWK=/usr/bin/awk
### !!!!!!!!!!!!!!!!!!  change 1.stline; name to /etc/init.d/iptables.custom; and IFACE:
IFACE=eth0

#           for the bridged firewall: br-lan

A=`/sbin/ifconfig $IFACE | $GREP -A 1 $IFACE | $TAIL -1 | $GREP -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ` 

MYIP=`/bin/echo $A | $AWK -F" " '{print $1}'`

MYMask=`/bin/echo $A | $AWK -F" " '{print $NF}'`
MYMask="255.255.255.0" 
/bin/echo my IP = $MYIP
 
LOCALIP=$MYIP


stop() {
        echo "DANGER: Unloading firewall's Packet Filters!"
        $IPTABLES --flush
        $IPTABLES -P INPUT ACCEPT
        $IPTABLES -P FORWARD ACCEPT
        $IPTABLES -P OUTPUT ACCEPT
}

start() {
	echo "Loading custom bridging firewall script for MAC filtering"

	# Flush active rules, custom tables
	$IPTABLES --flush
	$IPTABLES --delete-chain

#------I do not set default drop -----------------
#	# Set default-deny policies for all three default tables
#	$IPTABLES -P INPUT DROP
#	$IPTABLES -P FORWARD DROP
#	$IPTABLES -P OUTPUT DROP

	# Don't restrict loopback (local process intercommunication)
	$IPTABLES -A INPUT -i lo -j ACCEPT
	$IPTABLES -A OUTPUT -o lo -j ACCEPT

	# Block attempts at spoofed loopback traffic
	$IPTABLES -A INPUT -s $LOCALIP -j DROP

	# Allow SSH to firewall from the local LAN
	$IPTABLES -A INPUT -p tcp -s $LOCALLAN --dport 22 -j ACCEPT
	$IPTABLES -A OUTPUT -p tcp --sport 22 -j ACCEPT

        # Allow HTTP to firewall from the local LAN    
        $IPTABLES -A INPUT -p tcp -s $LOCALLAN --dport 80 -j ACCEPT                     
        $IPTABLES -A OUTPUT -p tcp --sport 80 -j ACCEPT                                 
        $IPTABLES -A INPUT -p tcp -s $LOCALLAN --dport 443 -j ACCEPT                     

	# pass DNS queries and their replies
	$IPTABLES -A FORWARD -p udp -s $LOCALLAN --dport 53 -j ACCEPT
	$IPTABLES -A FORWARD -p tcp -s $LOCALLAN --dport 53 -j ACCEPT
	$IPTABLES -A FORWARD -p udp --sport 53 -d $LOCALLAN -j ACCEPT
	$IPTABLES -A FORWARD -p tcp --sport 53 -d $LOCALLAN -j ACCEPT
	
#	# cleanup-rules
#	$IPTABLES -A INPUT -j DROP
#	$IPTABLES -A OUTPUT -j DROP
#	$IPTABLES -A FORWARD -j DROP

for MAC in `cat mac_addresses_file`; do
    echo mac=$MAC
#  iptables -A FORWARD -i eth0 -o eth1 -m mac --mac-source $MAC -j ACCEPT
done

#iptables -P FORWARD  DROP


}



