### Container performing iptables NAT to provide Internet access to GNS3 topologies.

From the container console start the **nat.sh** script from **/data** directory
Configure /data/nat.sh according to your topology, then start it start dnsmasq for DHCP and iptables for NAT (masquerade)

> sh /data/nat.sh




#### References:
https://github.com/GNS3/gns3-registry/tree/master/docker/dhcp
