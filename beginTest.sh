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
echo "Starting execution..."
for HOSTNAME in ${HOSTS}; do
	#Connect to each server and run nmon process
	ssh ${USERNAME}@${HOSTNAME} ~/nmon_x86_64_centos6 -s 10 -ft -c 9999
	echo "nmon in server ${HOSTNAME} started..."
done
#
#Connect JMX and get SQL dump
java -jar ${cmdLineJMXJar} - ${jmxHost}:${port} com.genexus.performance:type=DataStoreProviders dumpDataStoresInformation
#
#Run JMeter test
~/apache-jmeter-3.0/bin/jmeter -n -t "/root/script/Script.jmx" -r
#
echo "Execution started"