# Network-Management
Implementation of a network topology with redundancy, load balancing, failover, routing and SNMP monitoring. Using snmpd, OSPF and BGP routing protocols in Quagga, keepalived and some Shell scripts. All of it running into customized Tiny Core virtual machines.
## Structure of the project
* Access Layer
  * In this layer we find our Web Servers.
* Distribution Layer
  * Inner routers and load balancers are found in this layer.
* Kernel Layer
  * Here we find our boundary routers using BGP to comunicate with outer networks.

The following image shows the network topology and respective IP's for each device in the network.
![Network Topology](/images/network-topology.png)
