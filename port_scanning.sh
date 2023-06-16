#! /bin/bash

# 1 folder 
# 2 input_file

#GOBIN=/home/$USER/go/bin/home/$USER/go/bin
while getopts 'c:m:s:e:' OPTION; do
  case "$OPTION" in
    c)
      c="$OPTARG"
      echo "company provided is $OPTARG"
      ;;
    m)
      m="$OPTARG"
      echo "main domain is $OPTARG"

      ;;
    s)
      s="$OPTARG"
      echo "single domain provided is $OPTARG"
      ;;
    ?)
      echo "script usage: $(basename \$0) url [-p" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

i=0

dest_file=$c"/out_alive.txt"


if [ ! -z "$s" ]
  then
    
    dest_file=$c"/temp_out_alive.txt"
if [[ "$s" == *"//"* ]]; then
           echo $s | awk -F '//' '{print$s}' > $c"/temp_out_alive.txt"
    else
         echo $s > $c"/temp_out_alive.txt"
    fi
    fi

for l in $(cat $dest_file);

do
    mkdir -p $c"/"$l

    FILE=$c"/"$l"/out_nmap_top_1000_ports_naabu"
    #if [ -s diff.txt ]; then
    if [[ ! -f "$FILE"  || ! -s "$FILE" ]]; then
        echo "NAABU $l "
        if [[ $i -le 2 ]]; then  
            #nmap -sC -sV -v $l -oA $c"/"$l"/out_nmap_top_1000_ports" -T3 --top-ports 1000 -Pn &
            `#$GOBIN/`naabu -host $l -top-ports 100 -cdn -ec -c 10 -rate 100 -o $c"/"$l"/out_nmap_top_1000_ports_naabu" -sa -resume -no-stdin -Pn & #-nmap-cli "nmap -Pn -sC -sV -oN $c/$l/out_nmap_top_1000_ports_nmap" 
            i=$((i+1))
        else
            wait
            i=1     
            #nmap -sC -sV -v $l -oA $c"/"$l"/out_nmap_top_1000_ports" -T3 --top-ports 1000 -Pn &
            `#$GOBIN/`naabu -host $l -top-ports 100 -cdn -ec -c 10 -rate 100 -o $c"/"$l"/out_nmap_top_1000_ports_naabu" -sa -resume -no-stdin -Pn & #-nmap-cli "nmap  -Pn -sC -sV -oN $c/$l/out_nmap_top_1000_ports_nmap" 
        fi
    fi

    
done

#cat nmap/out_nmap_top_1000_2.gnmap | awk -F'[/ ]' '{h=$s; for(i=1;i<=NF;i++){if($i=="open"){print h,$(i-1)}}}' | sed 's/ /:/'


# NMAP_FILE=$c"/nmap/out_nmap_top_1000_2"

# egrep -v "^#|Status: Up" $NMAP_FILE | cut -d' ' -f2 -f4- | \
# sed -n -e 's/Ignored.*//p'  | \
# awk '{print "Host: " $c " Ports: " NF-1; for(i=2; i<=NF; i++) { a=a" "$i; }; split(a,s,","); for(e in s) { split(s[e],v,"/"); printf "$c%-8s %s/%-7s %s\n" , v[2], v[3], v[1], v[5]}; a="" }'
