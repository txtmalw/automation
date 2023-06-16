#!/bin/bash

i=0

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

source ./content_discovery.sh 

folder="$c"
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

for dom in $(cat $dest_file);
    do  
        #echo $dom
        FILE=$c"/"$dom"/alive_web_app.txt"
        if [[ -f "$FILE" ]]; then
            for l in $(cat $c"/"$dom"/alive_web_app.txt");
                do

                    proxy_https_random=$(shuf -n 1 /tmp/goodproxies.txt)

                    # domain_and_port=$(echo $l | sed 's/:\/\//_/' | sed 's/:/_/')

                    # if [[ -f $domain_and_port"/final_urls_sorted_and_unique.txt"]]; then

                    #echo $l
                    domain=$(echo $l | awk -F ":" '{print $s}'  | sed 's/\/\///')
                    #echo $domain
                    if [[ $i -le 1 ]]; then 
                        ./content_discovery.sh  -o $c"/"$dom -u $l -p "https://$proxy_https_random" &
                        #./crawler.sh 
                        i=$((i+1))
                    else
                        wait < <(jobs -p)
                        i=1
                        ./content_discovery.sh  -o $c"/"$dom -u $l  -p "https://$proxy_https_random" &
                    fi
		echo "content"
                done
        fi
    done
