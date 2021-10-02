#!/bin/bash

echo -e "protocol:\n1 TCP\n2 UDP\n3 ICMP\n4 GRE"
read -p 'Enter the number of key protocol above you wish to search [1,2,3 or 4]: ' selprotocol

case $selprotocol in
     1) awk 'BEGIN {FS=","; NR>1} $3 ~/TCP/ && $13 ~/suspicious/ { printf "%-5s %-15s %-10s %-15s %-10s %-5s %-10s %-10s\n", $3, $4, $5, $6, $7, $8, $9, $13}' < serv_acc_log_12032020.csv > tempresult.csv && cat tempresult.csv;;
     2) awk 'BEGIN {FS=","; NR>1} $3 ~/UDP/ && $13 ~/suspicious/ { printf "%-3s %-15s %-10s %-15s %-10s %-5s %-10s %-10s\n", $3, $4, $5, $6, $7, $8, $9, $13}' < serv_acc_log_12032020.csv > tempresult.csv && cat tempresult.csv;;
     3) awk 'BEGIN {FS=","; NR>1} $3 ~/ICMP/ && $13 ~/suspicious/ { printf "%-4s %-15s %-10s %-15s %-10s %-5s %-10s %-10s\n", $3, $4, $5, $6, $7, $8, $9, $13}' < serv_acc_log_12032020.csv > tempresult.csv && cat tempresult.csv;;
     4) awk 'BEGIN {FS=","; NR>1} $3 ~/GRE/ && $13 ~/suspicious/ { printf "%-3s %-15s %-10s %-15s %-10s %-5s %-10s %-10s\n", $3, $4, $5, $6, $7, $8, $9, $13}' < serv_acc_log_12032020.csv > tempresult.csv && cat tempresult.csv;;
     *) echo "Invalid selection. Exit Program." && exit 1;;
esac

echo -e "\n"
read -p 'Name your output file: ' filename
mv tempresult.csv $filename.csv && echo "The $filename.csv outputfile is saved." && ls

exit 0