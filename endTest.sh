#!/bin/bash
#set variables:
##################################
USERNAME=root
#Servers
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
#TO-DO: Make a generic function for progress bar
#TO-DO: upgrade granularity of progress bar on each for loop whit more than one log
##################################
#
#Connect to JMX and get SQL dump
java -jar ${cmdLineJMXJar} - ${jmxHost}:${port} com.genexus.performance:type=DataStoreProviders dumpDataStoresInformation
#
mkdir ~/Logs
echo "transfering logs..."
echo "..."
elapsed=1
duration=$(wc -w <<< "$HOSTS")
#Getting logs from each server
for HOSTNAME in ${HOSTS} ; do
	#Create logs directory
	mkdir ~/Logs/${HOSTNAME}
	#kill nmon proccess
	PIDNMON=$(ssh ${USERNAME}@${HOSTNAME} /bin/ps -fu root | grep nmon | grep -v grep | awk '{print $2}')
	#echo "nmon PID: ${PIDNMON}"
	ssh ${USERNAME}@${HOSTNAME} kill ${PIDNMON}
	#get nmon logs
	scp ${USERNAME}@${HOSTNAME}:~/*.nmon ~/Logs/${HOSTNAME}
	already_done; remaining; percentage
	echo " -----> nmon log obtained, and proccess ${PIDNMON} in ${HOSTNAME} server ended"
	clean_line
    elapsed=$((elapsed + 1))
done
echo "All NMON logs transfered..."
#
#Get AppServer gc, access and server logs
JBOSS="192.168.0.1"
DATE2=$(date +"%Y-%m-%d")
elapsed=1
duration=$(wc -w <<< "$JBOSS")
for JBOSSNAME in ${JBOSS} ; do
	#Get logs
	scp ${USERNAME}@${JBOSSNAME}:/opt/jboss/domain/log/gc.log ~/Logs/${JBOSSNAME} #gc log
	scp ${USERNAME}@${JBOSSNAME}:/opt/jboss/domain/servers/server/log/access_log.${DATE2} ~/Logs/${JBOSSNAME} #access log
	scp ${USERNAME}@${JBOSSNAME}:/opt/jboss/domain/servers/server/log/server.log ~/Logs/${JBOSSNAME} #server log
	already_done; remaining; percentage
	echo " -----> logs from ${JBOSSNAME} server obtained"
	clean_line
    elapsed=$((elapsed + 1))
done
echo "JBOSS logs transfered..."
#
#Get load balancers access and error logs
BALANCERS="192.168.0.2"
DATE=$(date +"%Y.%m.%d")
elapsed=1
duration=$(wc -w <<< "$BALANCERS")
for BALANCNAME in ${BALANCERS} ; do
	scp ${USERNAME}@${BALANCNAME}:/var/log/httpd/access_log.${DATE} ~/Logs/${BALANCNAME} #access log
	scp ${USERNAME}@${BALANCNAME}:/var/log/httpd/error_log.${DATE} ~/Logs/${BALANCNAME} #error log
	already_done; remaining; percentage
	echo " -----> logs from ${BALANCNAME} server obtained"
	clean_line
    elapsed=$((elapsed + 1))
done
echo "load balancer logs transfered..."
#
#Get native DB log
PSQL="192.168.0.3"
DAY=$(date +"%a")
elapsed=1
duration=$(wc -w <<< "$PSQL")
for BD in ${PSQL} ; do
	#Get log
	scp ${USERNAME}@${BD}:/var/lib/pgsql/9.5/data/pg_log/postgresql-${DAY}.log ~/Logs/${PSQL}
	already_done; remaining; percentage
	echo " -----> logs from ${BD} server obtained"
	clean_line
    elapsed=$((elapsed + 1))
done
echo "DB log transfered..."
echo "The End."