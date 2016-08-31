#!/bin/bash

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
  interface=eth2
  dhcp-option=eth2,3,10.0.0.1
  dhcp-option=eth2,6,192.168.0.254
  dhcp-range=eth2,10.0.0.10,10.0.0.20,12h
  
  # Second LAN interface
  interface=eth0
  dhcp-option=eth0,3,11.0.0.1
  dhcp-option=eth0,6,192.168.0.254
  dhcp-range=eth0,11.0.0.10,11.0.0.20,12h

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
iptables -A FORWARD -i eth0 -j ACCEPT
iptables -A FORWARD -i eth2 -j ACCEPT
iptables --t nat -F POSTROUTING
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth1 -j ACCEPT
iptables --t nat -A POSTROUTING -o eth1 -j MASQUERADE

echo "Edit /etc/dnsmasq/dnsmaq.conf to change the configuration"
dnsmasq --log-dhcp --no-daemon --conf-file=/etc/dnsmasq/dnsmaq.conf 



