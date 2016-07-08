#!/bin/bash

echo -n "Enter the name of LAN interface and press [ENTER]: "
read LAN

echo -n "Enter the name of WAN interface and press [ENTER]: "
read WAN

echo -n "Enter DHCP range start IP and press [ENTER]: "
read START

echo -n "Enter DHCP range end IP and press [ENTER]: "
read END


mkdir -p /etc/dnsmasq

if [ ! -f /etc/dnsmasq/dnsmaq.conf ]
then
    cat > /etc/dnsmasq/dnsmaq.conf <<EOF
# dnsmasq will open tcp/udp port 53 and udp port 67 to world to help with
# dynamic interfaces (assigning dynamic ips). Dnsmasq will discard world
# requests to them, but the paranoid might like to close them and let the 
# kernel handle them:
bind-interfaces
# Dynamic range of IPs to make available to LAN pc
dhcp-range=$START,$END,12h
EOF
fi

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $LAN -j ACCEPT
iptables --t nat -F POSTROUTING
iptables --t nat -A POSTROUTING -o $WAN -j MASQUERADE

echo "Edit /etc/dnsmasq/dnsmaq.conf to change the configuration"
dnsmasq --log-dhcp --no-daemon --conf-file=/etc/dnsmasq/dnsmaq.conf 
