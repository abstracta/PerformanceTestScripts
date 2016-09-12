# PerformanceTestScripts
Shell scripts (Batch scripts soon) to do pre and post execution tasks, in performance testing, like start and stop monitoring tools, get logs, organize them in folders, etc.

## IMPORTANT: 
-Each script uses several routes (to logs, programs, etc.), it's important to have the same routes for each file in our system, or edit the scripts in order to have them working properly.
-One of the scripts functionalities is to take an SQL dump thorugh JMX for GeneXus apps, this must be configured before using the scripts. More information about this could be found in: http://wiki.genexus.com/commwiki/servlet/wiki?1997,Monitoring+and+Management+of+GX+applications.

## The Scripts:

### startJMeterServers
Starts jmeter-server process in each server declared in *HOSTS* variable. Very useful in JMeter remote testing (distributed testing) with various servers.
The scripts connect through ssh, so in order to have the script working properly its necessary to set a ssh user in *USERNAME* variable and the remote servers in *HOSTS* variable. The ssh user must be the same for all servers.

### beginTest
Starts nmon process in each server declared in *HOSTS* variable, gets an SQL dump through JMX (only for GeneXus applications) from the host declared in *jmxHost* variable and runs a JMeter test.
The scripts connect through ssh, so in order to have the script working properly its necessary to set a ssh user in *USERNAME* variable and the remote servers in *HOSTS* variable. The ssh user must be the same for all servers.
To get the JMX SQL dump properly, a Command-line JMX Client file (like this one: *http://crawler.archive.org/cmdline-jmxclient/*) must be specified in *cmdLineJMXJar* variable, and the host and server port for JMX in *jmxHost* and *port* variables.
The JMeter command is run for remote testing (*-r* argument) and a script named *Script.jmx* located in */root/script/* directory. This line must be changed in order to run another test.

### endTest
Kills and get the log from the nmon process in each server declared in *HOSTS* variable, gets an SQL dump through JMX (only for GeneXus applications) from the host declared in *jmxHost* variable, gets the server log, access log and gc log from each appserver declared in *JBOSS* variable, the access log and error log from each load balancer declared in *BALANCERS* variable, and the DB log from each DB declared in *PSQL* variable.
It also creates a "Logs" directory with a specific directory for each server declared in *HOSTS* to store all the obtained logs.
The scripts connect through ssh, so in order to have the script working properly its necessary to set a ssh user in *USERNAME* variable and the remote servers in *HOSTS*, *JBOSS*, *BALANCERS* and *PSQL* variables. The ssh user must be the same for all servers.
To get the JMX SQL dump properly, a Command-line JMX Client file (like this one: *http://crawler.archive.org/cmdline-jmxclient/*) must be specified in *cmdLineJMXJar* variable, and the host and server port for JMX in *jmxHost* and *port* variables.

Getting the JMX SQL dump before and after the test execution could be very useful in order to get the SQL's queries executed during the test using GXSQLDiffenrence: https://github.com/abstracta/GXSQLDifference
