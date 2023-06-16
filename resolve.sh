#! /bin/bash

for l in $(cat $2)
do

	if [[ ! "$3" == *"$l"* ]]; then
	#echo "It's there."
	l=$(echo "$l" | awk -F '?' '{print $1}')
	out=$(host $l)
#	echo $out
	if [[ "$out" != *"not found"* &&  "$out" != *"timed out"* ]]; then
  		echo $l >> $1"/"out_alive.txt
		#nmap -sC -sV --top-ports 10000 -T3 -Pn $l -oA $nmapout"/"$l"_out_nmap_10000" &
	fi
	fi
done;
