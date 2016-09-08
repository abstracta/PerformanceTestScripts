#!/bin/bash
#set variables:
##################################
USERNAME=root
#jmeter servers:
HOSTS="192.168.0.1 192.168.0.2 192.168.0.3"
##################################
echo "Starting JMeter-servers..."
for HOSTNAME in ${HOSTS}; do
	#Connect to the servers through ssh and run jmeter-server.sh
	ssh ${USERNAME}@${HOSTNAME} screen -d -m ~/apache-jmeter-3.0/bin/jmeter-server
	echo "jmeter-server in ${HOSTNAME} started..."
done
#
echo "all servers started..."