#!/bin/bash
#Michael Edwards
#20th July 2021
#
#Cisco Software Version Checker
#This script will query a Cisco device and retrieve the SNMP device version
#Prerequisite - Enable SNMP polling on Cisco device
#Usage ciscoversioncheck.sh *Community String 'IP address of cisco device'
#e.g.  Type 'ciscoversioncheck.sh public 192.168.0.1' to query the Cisco Software Version
#
#Declare Postional Parameters (Command Line argument)
community=$1
hostip=$2
#
snmpget -v2c -c $community $hostip 1.3.6.1.4.1.9.9.25.1.1.1.2.7 |grep Version| sed 's/.*Version //' | cut -d "," -f 1
