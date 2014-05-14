Firewalls
=========

transparent firewall (I cannot use physdev neither iprange)
 and 
 mac filtering  (works)                openwrt  setups



EDIT: `vi /etc/init.d/iptables.custom`

APPLY: `/etc/init.d/iptables.custom  start`






---------------OPENWRT transparent firewall-------------------  
Pre-requisites:  
http://www.linuxjournal.com/article/10899?page=0,2  

Recompiling the OpenWrt image with CONFIG_BRIDGE_NETFILTER=y 

/etc/sysctl.conf or set each to  "1"  
```
net.bridge.bridge-nf-call-arptables=0  
net.bridge.bridge-nf-call-ip6tables=0  
net.bridge.bridge-nf-call-iptables=0  
```  
br-lan that connects  `eth0.1 and eth0.2`    is perfect,  
two vlans @switch connect cpu+ports (vlan1:1  and  vlan2:2,3,4,5  )  


`opkg install `  
`iptables-mod-extra ` ( --force-depends when kernel compiled)  

i stop here, iptables   `-m physdev`   locks-up  and I want it    

---------------------------------------------------
```
Requirements

Note that if you need a bridge but do not need to restrict the traffic through the bridge then any version of Shorewall will work. See the Simple Bridge documentation for details.

In order to use Shorewall as a bridging firewall:

Your kernel must contain bridge support (CONFIG_BRIDGE=m or CONFIG_BRIDGE=y).

Your kernel must contain bridge/netfilter integration (CONFIG_BRIDGE_NETFILTER=y).

Your kernel must contain Netfilter physdev match support (CONFIG_IP_NF_MATCH_PHYSDEV=m or CONFIG_IP_NF_MATCH_PHYSDEV=y). Physdev match is standard in the 2.6 kernel series but must be patched into the 2.4 kernels (see http://bridge.sf.net). Bering and Bering uCLibc users must find and install ipt_physdev.o for their distribution and add “ipt_physdev” to /etc/modules.

Your iptables must contain physdev match support and must support multiple instances of '-m physdev' in a single rule. iptables 1.3.6 and later contain this support.

You must have the bridge utilities (bridge-utils) package installed.
```
