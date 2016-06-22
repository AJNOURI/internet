#!/bin/bash

LAN="eth1"
INT="eth0"

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
iptables --t nat -A POSTROUTING -o $INT -j MASQUERADE
