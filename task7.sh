#!/bin/bash

read -p "Enter a value you wish to search: " value
read -p "Choose to search 1/ greater than, 2/ less than, 3/ equal to or 4/ not equal to $value [1,2,3 or 4]: " range

sel=serv_acc_log_14032020.csv

grep "suspicious$" $sel > tempfile.csv

case $range in
     1) awk ' BEGIN {FS=","; ttlpackets=0; ttlbytes=0} 
     NR>1 {
           if ( $9 > '"$value"' )
            { 
              ttlpackets=ttlpackets+$9
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
           }
           END { print "Total size for all matching rows is ", ttlpackets, " bytes." }
           ' < tempfile.csv > tempresult.csv && cat tempresult.csv;; 
     2) awk ' BEGIN {FS=","; ttlpackets=0; ttlbytes=0} 
     NR>1 {
           if ( $9 < '"$value"' )
            { 
              ttlpackets=ttlpackets+$9
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
           }
           END { print "Total size for all matching rows is ", ttlpackets, " bytes." }
           ' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
     3) awk ' BEGIN {FS=","; ttlpackets=0; ttlbytes=0} 
     NR>1 {
           if ( $9 = '"$value"' )
            { 
              ttlpackets=ttlpackets+$9
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
           }
           END { print "Total size for all matching rows is ", ttlpackets, " bytes." }
           ' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
     4) awk ' BEGIN {FS=","; ttlpackets=0; ttlbytes=0} 
     NR>1 {
           if ( $9 != '"$value"' )
            { 
              ttlpackets=ttlpackets+$9
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
           }
           END { print "Total size for all matching rows is ", ttlpackets, " bytes." }
           ' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
     *) echo "Invalid input. Exit programme." && exit 1;;
esac

exit 0