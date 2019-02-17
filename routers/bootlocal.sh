#!/bin/sh
# Permitir uso de IPV6 (necesario para snmpd).
modprobe ipv6
# HAbilitar las interfaces ethernet.
opt/eth-interfaces.sh &
# Habilitar IP forwarding, necesario para permitir la transferencia
# de paquetes a traves de las interfaces de red en los protocolos
# usados por Quagga.
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
# Iniciar los demonios de Quagga para el enrutamiento.
sudo zebra -u root -d -f /home/tc/conf/zebra.conf
sudo ospfd -u root -d -f /home/tc/conf/ospfd.conf
#sudo bgpd -u root -d -f /home/tc/conf/bgpd.conf
# Iniciar Keepalived para el VRRP.
sudo keepalived -P -l -f /home/tc/conf/keepalived.conf
# Inicial el agente SNMP con las configuraciones personalizadas.
sudo snmpd -C -c /home/tc/conf/snmpd.conf
