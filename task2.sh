#!/bin/bash

read -p 'Enter the code you wish to search: ' selsrcip

awk 'BEGIN {FS=","; NR>1} $4 ~ /'$selsrcip'/ && $13 ~/suspicious/ { printf "%-5s %-15s %-10s %-15s %-10s %-5s %-10s %-10s\n", $3, $4, $5, $6, $7, $8, $9, $13}' < serv_acc_log_12032020.csv > tempresult.csv && cat tempresult.csv

exit 0