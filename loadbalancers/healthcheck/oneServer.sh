#!/bin/sh
# Eliminar las reglas de firewall previas para los puertos
iptables --flush
# Eliminar las reglas en la tabla NAT
iptables -t nat --flush
# Insertar las reglas en la tabla NAT para el servidor definido como parametro
iptables -t nat -p tcp -A POSTROUTING --source 10.0.2.0/24 -d 10.0.3.0/24 --dport 80 -j MASQUERADE
iptables -t nat -p tcp -A PREROUTING -d 10.0.2.10 --dport 80 -j DNAT --to-destination $1
# Habilitar las conexiones al puerto 80 del servidor dado como parametro
iptables -A FORWARD -p tcp -d $1 --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
