#!/bin/bash

scount=0

while true; do # using while loop to keep the script running or to break it
  if [[ $scount = 0 ]];then #if user runs the script for the 1st time
     read -p "Enter [1] to search or [2] to exit: "
  else # if user runs the script more than once
    echo -e "\n"
    read -e -p "Enter [1] to search again or [2] to exit: "
fi
  
  if [[ $REPLY = 2 ]]; then #break to loop if user enters [2]
  break
  else
((scount++))

clear

# declare array of files named serserv_acc_log.+csv in the working directory and list them out
declare -a logs
patt="serv_acc_log.+csv$" 
mennum=1

for file in ./*; do
    if [[ $file =~ $patt ]]; then
       logs+=($(basename $file))
    fi
done

count=${#logs[*]}
echo -e "The logs array contains $count files.\n"

for file in "${logs[@]}"; do
    echo -e "$mennum $file"
    ((mennum++))
done

# use function to encapsulate commands for saving the specified file name 
savefile() {
  filename1=$(date +%d%m%Y_%T)
  filename2=$(date +%T_%d%m%Y)
  echo -e "\n"
  echo -e "File Name Formats:\n1 date_time i.e.[30092021_15:39:07]\n2 time_date i.e. [15:39:07_30092021]\n"
  read -p 'Enter the number of format in the menu above you wish to name your output file [1 or 2]: ' selffilename

  case $selffilename in
    1) mv tempresult.csv $filename1.csv && echo -e "\nThe output file $filename1.csv is saved.\n" && ls;;
    2) mv tempresult.csv $filename2.csv && echo -e "\nThe output file $filename2.csv is saved.\n" && ls;;
    *) mv tempresult.csv $filename1.csv && echo -e "\nInvalid input. The output file is saved as $filename1.csv anyway.\n" && ls;;
  esac
}

# prompt user to select a file listed in the menu
echo -e "\n"
read -p "Enter the number of the file in the menu above you wish to search [1,2,3,4,5 or 6 for searching all files]: " sel
  case $sel in
    [1-5]) fileopt=${logs[$sel-1]} # for option 1 to 5, declare the representing file
         grep "suspicious$" $fileopt > tempfile.csv;; # filter all contents classed suspicious from the selected file& output the file, for further action
    6)   fileopt=${logs[*]} # for option 6, declare all files in the working directory
         grep "suspicious$" $fileopt > tempfile.csv;;# filter all contents classed suspicious from all files in working directory& output the file, for further action
    *)   echo "Invaild input. Exit programme." && exit 1;;
  esac

  clear
  echo -e "You have entered $fileopt\n"


# prompt user to select a search field listed in the menu
clear
echo -e "Search Fields:\n1 PROTOCOL\n2 SRC IP\n3 SRC PORT\n4 DEST IP\n5 DEST PORT\n6 PACKET\n7 BYTES\n"
read -p 'Enter the number of field in the menu above you wish to search [1,2,3,4,5,6 or 7]: ' selfield


# use function to encapsulate commands for searching specified protocol 
task1(){
  echo -e "\n"
  echo -e "Protocols:\n1 TCP\n2 UDP\n3 ICMP\n4 GRE\n"
  read -p 'Enter the number of key protocol above you wish to search [1,2,3 or 4]: ' selprotocol

  case $selprotocol in
       1) awk 'BEGIN {FS=","; NR>1} $3 ~/TCP/ { printf "%-5s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 }' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
       2) awk 'BEGIN {FS=","; NR>1} $3 ~/UDP/ { printf "%-3s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 }' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
       3) awk 'BEGIN {FS=","; NR>1} $3 ~/ICMP/ { printf "%-4s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 }' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
       4) awk 'BEGIN {FS=","; NR>1} $3 ~/GRE/ { printf "%-3s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 }' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
       *) echo "Invalid selection. Exit Program." && exit 1;;
  esac
}


# use function to encapsulate commands for searching specified Source IP, set the search to be case insensitive with [tolower]& [toupper]
task2(){
  read -p 'Enter the code you wish to search: ' selsrcip

  awk 'BEGIN {FS=","} 
  NR>1 {
           if ( tolower($4) ~/'"$selsrcip"'/ || toupper($4) ~/'"$selsrcip"'/ )
            { 
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
       }' < tempfile.csv > tempresult.csv && cat tempresult.csv
}


# use function to encapsulate commands for searching specified Source Port
task3(){
  read -p 'Enter the SRC PORT you wish to search: ' selsrcport
  awk 'BEGIN {FS=","; NR>1} $5 ~ /'$selsrcport'/ { printf "%-5s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 }' < tempfile.csv > tempresult.csv && cat tempresult.csv
}


# use function to encapsulate commands for searching specified Destination IP, set the search to be case insensitive with [tolower]& [toupper]
task4(){
  read -p 'Enter the code you wish to search: ' seldestip

  awk 'BEGIN {FS=","} 
  NR>1 {
         if ( tolower($6) ~/'"$seldestip"'/ || toupper($6) ~/'"$seldestip"'/ )
            { 
              printf "%-6s %-15s %-10s %-15s %-7s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
     }' < tempfile.csv > tempresult.csv && cat tempresult.csv
}


# use function to encapsulate commands for searching specified Destination Port
task5(){
  read -p 'Enter the DEST PORT you wish to search: ' seldestport
  awk 'BEGIN {FS=","; NR>1} $7 ~ /'$seldestport'/ { printf "%-5s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9 }' < tempfile.csv > tempresult.csv && cat tempresult.csv
}


# use function to encapsulate commands for searching packet in specified sizes, total size of matching search would be displayed as the final row 
task6(){
  read -p "Enter a value you wish to search: " value
  read -p "Choose to search 1/ greater than, 2/ less than, 3/ equal to or 4/ not equal to $value [1,2,3 or 4]: " range

cct=$value
case $range in
     1) awk ' BEGIN {FS=","; ttlpackets=0; ttlbytes=0} 
     NR>1 {
           if ( $8 > '"$value"' )
            { 
              ttlpackets=ttlpackets+$8
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
           }
           END { print "Total packets for all matching rows is ", ttlpackets }' < tempfile.csv > tempresult.csv && cat tempresult.csv;; 
     2) awk ' BEGIN {FS=","; ttlpackets=0; ttlbytes=0} 
     NR>1 {
           if ( $8 < '"$value"' )
            { 
              ttlpackets=ttlpackets+$8
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
           }
           END { print "Total packets for all matching rows is ", ttlpackets }' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
     3) awk ' BEGIN {FS=","; ttlpackets=0; ttlbytes=0} 
     NR>1 {
           if ( $8 == '"$value"' )
            { 
              ttlpackets=ttlpackets+$8
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
           }
           END { print "Total packets for all matching rows is ", ttlpackets }' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
     4) awk ' BEGIN {FS=","; ttlpackets=0; ttlbytes=0} 
     NR>1 {
           if ( $8 != '"$value"' )
            { 
              ttlpackets=ttlpackets+$8
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
           }
           END { print "Total packets for all matching rows is ", ttlpackets }' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
     *) echo "Invalid input. Exit programme." && exit 1;;
esac
}

# use function to encapsulate commands for searching specified btyes value, total value of matching search would be displayed as the final row 
task7(){
  read -p "Enter a value you wish to search: " bvalue
  read -p "Choose to search 1/ greater than, 2/ less than, 3/ equal to or 4/ not equal to $value [1,2,3 or 4]: " brange

  case $brange in
     1) awk ' BEGIN {FS=","; ttlpackets=0; ttlbytes=0} 
     NR>1 {
           if ( $9 > '"$bvalue"' )
            { 
              ttlbytes=ttlbytes+$9
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
           }
           END { print "Total size for all matching rows is ", ttlbytes, " bytes." }' < tempfile.csv > tempresult.csv && cat tempresult.csv;; 
     2) awk ' BEGIN {FS=","; ttlpackets=0; ttlbytes=0} 
     NR>1 {
           if ( $9 < '"$bvalue"' )
            { 
              ttlbytes=ttlbytes+$9
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
           }
           END { print "Total size for all matching rows is ", ttlbytes, " bytes." }' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
     3) awk ' BEGIN {FS=","; ttlpackets=0; ttlbytes=0} 
     NR>1 {
           if ( $9 = '"$bvalue"' )
            { 
              ttlbytes=ttlbytes+$9
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
           }
           END { print "Total size for all matching rows is ", ttlbytes, " bytes." }' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
     4) awk ' BEGIN {FS=","; ttlpackets=0; ttlbytes=0} 
     NR>1 {
           if ( $9 != '"$bvalue"' )
            { 
              ttlbytes=ttlbytes+$9
              printf "%-6s %-15s %-10s %-15s %-10s %-5s %-10s \n", $3, $4, $5, $6, $7, $8, $9
            } 
           }
           END { print "Total size for all matching rows is ", ttlbytes, " bytes." }' < tempfile.csv > tempresult.csv && cat tempresult.csv;;
     *) echo "Invalid input. Exit programme." && exit 1;;
esac
}


# use case statement and functions listed above to run the whole solution
 case $selfield in
     1) task1
        savefile;;
     2) task2
        savefile;;
     3) task3
        savefile;;
     4) task4
        savefile;;
     5) task5
        savefile;;
     6) task6
        savefile;;
     7) task7
        savefile;;
     *) echo "Invalid selection, exiting program." && exit 1;;
esac

fi
done

exit 0