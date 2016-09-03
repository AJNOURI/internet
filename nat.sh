#!/bin/bash

dhcp(){                                                           
  if pgrep dnsmasq >/dev/null 2>&1; then 
    pkill dnsmasq
  fi
  dnsmasq --log-dhcp --conf-file=/etc/dnsmasq/dnsmaq.conf            
}

if [ ! -f /etc/dnsmasq/dnsmaq.conf ]; then
  mkdir -p /etc/dnsmasq
  cat > /etc/dnsmasq/dnsmaq.conf <<EOF
  # dnsmasq will open tcp/udp port 53 and udp port 67 to world to help with
  # dynamic interfaces (assigning dynamic ips). Dnsmasq will discard world
  # requests to them, but the paranoid might like to close them and let the 
  # kernel handle them:
  bind-interfaces
  # Dynamic range of IPs to make available to LAN pc
  
  # First LAN interface
  interface=ethi1
  dhcp-option=eth1,3,192.168.114.100
  dhcp-option=eth1,6,8.8.8.8
  dhcp-range=eth1,192.168.114.10,192.168.114.20,12h
  
  # Second LAN interface
  #interface=eth0
  #dhcp-option=eth0,3,11.0.0.1
  #dhcp-option=eth0,6,192.168.0.254
  #dhcp-range=eth0,11.0.0.10,11.0.0.20,12h
EOF

fi

# NAT (masquerade) deployment
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
#iptables -A FORWARD -i eth0 -j ACCEPT
iptables -A FORWARD -i eth1 -j ACCEPT
iptables --t nat -F POSTROUTING
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
#iptables -A FORWARD -i eth1 -o eth1 -j ACCEPT
iptables --t nat -A POSTROUTING -o eth0 -j MASQUERADE

read -p 'Would you like to run the dhcp server (dnsmasq)?  [Yy] [Nn]  ' ISDHCP
while true; do
  case $ISDHCP in
    [Nn]* ) break 1;;
    [Yy]* ) dhcp;;
    * ) echo "Please answer yes [Yy]* or no [Nn] *";;
   esac
done

