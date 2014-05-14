#!/bin/sh /etc/rc.common

START=46

EXTRA_COMMANDS="list"
EXTRA_HELP="        list  make list of macs"

MYNAME=/etc/init.d/macs

# 1 set static IP on WAN  openWRT
# 2 set dhcp on LAN
# 3 set this service active
#
#

ECHO=/bin/echo
IPTABLES=/usr/sbin/iptables
GREP=/bin/grep
TAIL=/usr/bin/tail
AWK=/usr/bin/awk
CAT=/bin/cat
CUT=/usr/bin/cut 
XARGS=/usr/bin/xargs

stop(){

 echo "deleting forwarding_rule "

while [ $? = 0 ]; do
 $IPTABLES -D forwarding_rule 1
done 

#       echo "DANGER: completely Unloading firewall's Packet Filters!"
#        $IPTABLES --flush
#        $IPTABLES -P INPUT ACCEPT
#        $IPTABLES -P FORWARD ACCEPT
#        $IPTABLES -P OUTPUT ACCEPT
}


start(){

echo "my name is $MYNAME"
echo "deleting forwarding_rule "

while [ $? = 0 ]; do
 $IPTABLES -D forwarding_rule 1
done 

echo  "creating forwarding_rule set..."


MACLIST=`$CAT $MYNAME  | $GREP -v \# |  $AWK  '/..\:..\:..\:..\:..\:../{print $1}'  `


for j in $MACLIST
do   
	$IPTABLES -A forwarding_rule -m mac --mac-source  $j  -j ACCEPT
done
	 $IPTABLES -A forwarding_rule -j DROP

echo "...MAC forwarding_rule applied"

}


list(){

echo list of mac addresses
################# DATA ##################################
# #### ?opkg install iptables-mod-ipopt
####################################################
echo "
11:22:33:44:55:66  123  jara
"
$IPTABLES -L | $GREP forwarding_rule -A 2
}





