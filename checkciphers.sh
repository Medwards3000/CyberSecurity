#! /usr/bin/ksh
# Credit to Gerard H Pile - https://serverfault.com/questions/1020494/scan-ip-range-for-ssl-tls-versions-and-vulnerabilities-with-legible-greppable-ou
# This script performs a NMAP scan of hosts. It parses the result to a list of Ciphers, e.g TLS 1.0, 1.1, etc and calculates number in each line. 
# Can be used in conjuction with "nmap -sV --script ssl-enum-ciphers -p 443 -iL network_subnets.list >cipherslist.txt". Just comment first line and second line.
#Result:
#192.168.1.1   TLSv1.0:3 TLSv1.1:3 TLSv1.2:5
#192.168.1.2   TLSv1.0:4 TLSv1.1:4
#hostABC (192.168.1.3) TLSv1.0:6 TLSv1.1:6 TLSv1.2:10

nmap -sV --script ssl-enum-ciphers -p 443 | awk '
#cat cipherslist.txt > | awk '
  /^Nmap scan report for /{
    currhost = $5 " " $6
  }
  /^443\/tcp /{
    if ($2 != "open") {
      currhost = ""
    }
  }
  /^\|   (TLS|SSL)/{
    currciph = $2
  }
  /^\|     ciphers:/{
    count = 1
    next
  }
  /^\|     [^ ]/{
    count = 0
  }
  /^\|       [^ ]/{
    if ("$currhost" && count > 0) {
      host[currhost] = 1
      ciph[currhost][currciph] += 1
    }
  }
  END {
    for (H in host) {
      CC=""
      for (C in ciph[H]) {
        CC=CC " " C ciph[H][C]
      }
      print H,CC
    }
  }
'
