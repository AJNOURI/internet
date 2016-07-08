### Container performing iptables NAT to provide Internet access to GNS3 topologies.

From the container console start the **nat.sh** script from **/data** directory
You will be asked to set the LAN and WAN interfaces as well as the IP range for dhcp clients connected to LAN interface, then the script will start dnsmasq and set iptables for NAT (masquerade)

> sh /data/nat.sh

to indicate LAN and WAN interfaces and set LAN DHCP range.



#### References:
https://github.com/GNS3/gns3-registry/tree/master/docker/dhcp
