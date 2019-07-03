#!/bin/bash
#set variables:
##################################
USERNAME=root
#jmeter servers:
HOSTS="192.168.0.1 192.168.0.2 192.168.0.3"
##################################
#Progress bar functions:
already_done() { for ((done=0; done<(elapsed) ; done=done+1 )); do printf "▇"; done }
remaining() { for (( remain=(elapsed) ; remain<(duration) ; remain=remain+1 )); do printf " "; done }
percentage() { printf "| %s%%" $(( ((elapsed)*100)/(duration)*100/100 )); }
clean_line() { printf "\033[A"; }
##################################
elapsed=1
duration=$(wc -w <<< "$HOSTS")
echo "Starting JMeter-servers..."
for HOSTNAME in ${HOSTS}; do
	#Connect to the servers through ssh and run jmeter-server.sh
	ssh ${USERNAME}@${HOSTNAME} screen -d -m ~/apache-jmeter-3.0/bin/jmeter-server
	already_done; remaining; percentage
	echo " -----> jmeter-server in ${HOSTNAME} started..."
	clean_line
    elapsed=$((elapsed + 1))
done
#
echo "all servers started..."