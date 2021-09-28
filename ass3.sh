#!/bin/bash

declare -a logs
patt="serv_acc_log.+csv$"
mennum=1

for file in ./*; do
    if [[ $file =~ $patt ]]; then
       logs+=($(basename $file))
    fi
done

count=${#logs[*]}
echo -e "The logs array contains $count file.\n"

for file in "${logs[@]}"; do
    echo -e "$mennum $file"
    ((mennum++))
done

echo -e "\t"
read -p "Enter the number of the file in the menu above you wish to search, i.e. [1,2,3,4 or 5]: " sel
echo -e "You have entered $sel\n"

echo -e "1 PROTOCOL\n2 SRC IP\n3 SRC PORT\n4 DEST IP\n5 DEST PORT\n6 PACKET\n7 BYTES"
read -e -p 'Enter the number of field in the menu above you wish to search, i.e. [1,2,3,4,5,6 or 7]: ' selfield

case $selfield in
     1) echo "You have selected field 1";;
     2) echo "You have selected field 2";;
     3) echo "You have selected field 3";;
     4) echo "You have selected field 4";;
     5) echo "You have selected field 5";;
     6) echo "You have selected field 6";;
     7) echo "You have selected field 7";;
     *) echo "Invalid selection, exiting program." && exit 1;;
esac

exit 0