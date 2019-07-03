#!/bin/bash
#Set variables:
##################################
USERNAME=root
#Servers:
HOSTS="192.168.0.1 192.168.0.2 192.168.0.3"
#JMX Variables
cmdLineJMXJar=./cmdline-jmxclient-0.10.3.jar
jmxHost=localhost
port=8999
##################################
#Progress bar functions:
already_done() { for ((done=0; done<(elapsed) ; done=done+1 )); do printf "▇"; done }
remaining() { for (( remain=(elapsed) ; remain<(duration) ; remain=remain+1 )); do printf " "; done }
percentage() { printf "| %s%%" $(( ((elapsed)*100)/(duration)*100/100 )); }
clean_line() { printf "\033[A"; }
##################################
elapsed=1
duration=$(wc -w <<< "$HOSTS")
#
echo "Starting execution..."
for HOSTNAME in ${HOSTS}; do
	#Connect to each server and run nmon process
	ssh ${USERNAME}@${HOSTNAME} ~/nmon_x86_64_centos6 -s 10 -ft -c 9999
	already_done; remaining; percentage
	echo " -----> nmon in server ${HOSTNAME} started..."
	clean_line
    elapsed=$((elapsed + 1))
done
#
#Connect JMX and get SQL dump
java -jar ${cmdLineJMXJar} - ${jmxHost}:${port} com.genexus.performance:type=DataStoreProviders dumpDataStoresInformation
#
#Run JMeter test
~/apache-jmeter-3.0/bin/jmeter -n -t "/root/script/Script.jmx" -r
#
echo "Execution started"