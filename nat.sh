#!/bin/bash

echo -n "Enter the name of LAN interface and press [ENTER]: "
read LAN

echo -n "Enter the name of WAN interface and press [ENTER]: "
read WAN

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

