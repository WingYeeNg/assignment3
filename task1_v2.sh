#!/bin/bash

echo -e "1 TCP\n2 UDP\n3 ICMP\n4 GRE"
read -p 'Enter the number of key protocol above you wish to search [1,2,3 or 4]: ' selprotocol

case $selprotocol in
     1) cat serv_acc_log_12032020.csv | grep -i 'suspicious' | awk 'BEGIN {FS=","} NR>1; $3~ /TCP/{ printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s\n", $3, $4, $5, $6, $7, $8, $9}' > tempresult.csv && cat tempresult.csv;;
     2) cat serv_acc_log_12032020.csv | grep -i s'suspicious' | awk 'BEGIN {FS=","} NR>1; $3~ /UDP/{ printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s\n", $3, $4, $5, $6, $7, $8, $9}' > tempresult.csv && cat tempresult.csv;;
     3) cat serv_acc_log_12032020.csv | grep -i 'suspicious' | awk 'BEGIN {FS=","} NR>1; $3~ /ICMP/{ printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s\n", $3, $4, $5, $6, $7, $8, $9}' > tempresult.csv && cat tempresult.csv;;
     4) cat serv_acc_log_12032020.csv | grep -i 'suspicious' | awk 'BEGIN {FS=","} NR>1; $3~ /GRE/{ printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s\n", $3, $4, $5, $6, $7, $8, $9}' > tempresult.csv &&ls
      cat tempresult.csv;;
     *) echo "Invalid selection. Exit Program." && exit 1;;
esac

exit 0s