#!/bin/sh

# Cargar las reglas de iptables por defecto (ambos servidores trabajando)
/home/tc/healthcheck/bothServers.sh
# Estado previo del servidor 1 (0 activo | 1 inactivo)
s1p=0
# Estado previo del servidor 2 (0 activo | 1 inactivo)
s2p=0
# Estado actual del servidor 1 (0 activo | 1 inactivo)
s1c=0
# Estado actual del servidor 2 (0 activo | 1 inactivo)
s2c=0
# Bandera para determinar si algun servidor fallo
changed=0
while :
do
	# Ping al servidor 1
	ping -c 1 -W 1 10.0.3.101 > /dev/null 2>&1
	pingS1=$?
	# Ping al servidor 2
	ping -c 1 -W 1 10.0.3.102 > /dev/null 2>&1
	pingS2=$?
	# Determinar si el ping al servidor 1 fue exitoso
	if [ $pingS1 -eq 0 ]; then
		s1c=0
	else
		s1c=1
	fi
	# Determinar si el ping al servidor 2 fue exitoso
	if [ $pingS2 -eq 0 ]; then
		s2c=0
	else
		s2c=1
	fi
	# Determinar si los estados actuales de los servidores coinciden con
	# los previos, y así saber si alguno fallo (o se recupero).
	if [ $s1c -eq $s1p ] && [ $s2c -eq $s2p ]; then
		changed=0
	else
		changed=1
	fi
	# Si un servidor esta caido (o se levanto)
	if [ $changed -eq 1 ]; then
		# Si ambos servidores estan activos
		if [ $s1c -eq 0 ] && [ $s2c -eq 0 ]; then
			/home/tc/healthcheck/bothServers.sh
			echo "Server #1 up, Server #2 up"
		# Si el Servidor 2 esta activo
		elif [ $s1c -eq 1 ] && [ $s2c -eq 0 ]; then
			/home/tc/healthcheck/oneServer.sh 10.0.3.102
			echo "Server #1 down, Server #2 up"
		# Si el servidor 1 esta activo
		elif [ $s1c -eq 0 ] && [ $s2c -eq 1 ]; then
			/home/tc/healthcheck/oneServer.sh 10.0.3.101
			echo "Server #1 up, Server #2 down"
		fi
	fi
	# Guardar los estados actuales de los servidores
	s1p=$s1c
	s2p=$s2c
	# Ejecutar la siguiente iteracion en un segundo
	sleep 1
done
