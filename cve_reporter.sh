#!/bin/bash 
#Michael Edwards (medwards3000@hotmail.com)
#19th July 2021
#prerequisite: JQ (Json Query must be installed). See link https://stedolan.github.io/jq/download/ for details. 
#Proxy:The below is configured to use proxy. Update *proxy* with corporate proxy hostname.
#
#Summary:
#This script will import a list of CVE's and then extract the relevant vulnerability details from it by querying the nist.gov website.
#Sometimes it is useful if you only know the software version of a device and the known CVE's to extract further information for reporting.
#For example if you know the software version in use on a Cisco switch, you can pull a list of CVE's using the "Cisco software checker"
#tool (https://tools.cisco.com/security/center/softwarechecker.x to check Cisco Vulnerabilities) and then use the below script to generate a comprehensive report
#prerequisite: JQ (Json Query must be installed). See link https://stedolan.github.io/jq/download/ for details. 
#The below is configured to use proxy. Update *proxy* with corporate proxy hostname.

cat cve.csv | \ 

while read A ; do 

        (curl -s -H "Accept: application/json" -x http://*proxy*:8080 https://services.nvd.nist.gov/rest/json/cve/1.0/$A -k |jq -r '[.result.CVE_Items[0].cve.CVE_data_meta.ID,.result.CVE_Items[0].cve.description.description_data[0].value ,.result .CVE_Items[0].impact.baseMetricV2.cvssV2.baseScore]|@csv') >>cveresults.csv 

done 
