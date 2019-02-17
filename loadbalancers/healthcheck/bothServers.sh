#!/bin/sh
# Eliminar las reglas de firewall previas para los puertos
iptables --flush
# Eliminar las reglas en la tabla NAT
iptables -t nat --flush
# Insertar las reglas en la tabla NAT para los servidores web
iptables -t nat -p tcp -A POSTROUTING --source 10.0.2.0/24 -d 10.0.3.0/24 --dport 80 -j MASQUERADE
# Implementacion del algoritmo Round Robin
iptables -t nat -p tcp -A PREROUTING -d 10.0.2.10 --dport 80 --match statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 10.0.3.101
iptables -t nat -p tcp -A PREROUTING -d 10.0.2.10 --dport 80 -j DNAT --to-destination 10.0.3.102
# Permitir las conexiones al puerto 80 a ambos servidores
iptables -A FORWARD -p tcp -d 10.0.3.101 --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p tcp -d 10.0.3.102 --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
