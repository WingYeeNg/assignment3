#!/bin/bash

echo -e "1 TCP\n2 UDP\n3 ICMP\n4 GRE"
read -p 'Enter the number of key protocol above you wish to search [1,2,3 or 4]: ' selprotocol

case $selprotocol in
     1) clear && grep -i 'TCP' serv_acc_log_12032020.csv > temp.csv | sed -i 's/normal/ /g' temp.csv | cat temp.csv;;
     2) grep -i 'UDP' serv_acc_log_12032020.csv > temp.csv && cat temp.csv | sed -i 's/normal/ /g' temp.csv | cat temp.csv;;
     3) grep -i 'ICMP' serv_acc_log_12032020.csv > temp.csv && cat temp.csv | sed -i 's/normal/ /g' temp.csv | cat temp.csv;;
     4) grep -i 'GRE' serv_acc_log_12032020.csv > temp.csv && cat temp.csv | sed -i 's/normal/ /g' temp.csv | cat temp.csv;;
     *) echo "Invalid selection. Exit Program." && exit 1;;
esac

exit 0