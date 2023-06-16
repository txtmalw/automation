#! /bin/bash
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
    FILE=$c"/"$l"/alive_web_app.txt"
    if [[ ! -f "$FILE"  ]]; then
        # FILE=$c"/"$l"/"out_nmap_top_1000_ports_naabu
        # if [[ -f "$FILE" ]]; then
            # echo "unique_ports: $l"
            # cat $c"/"$l"/"out_nmap_top_1000_ports_naabu | sort | uniq  | awk '{print $c}' > $c"/"$l"/"unique_ports
            # FILE=$c"/"$l"/"unique_ports 
            # if [[ -f "$FILE" ]]; then
                echo "httprobe: $l"
                echo echo $l | ~/go/bin/httprobe > $c"/"$l"/"alive_web_app.txt 
                echo $l | ~/go/bin/httprobe > $c"/"$l"/"alive_web_app.txt &
                wait < <(jobs -p)
                #FILE=$c"/"$l"/"alive_web_app.txt
                # if [[ -f "$FILE" ]]; then
                #     echo "alive_no_web_app: $l"
                #     cat $c"/"$l"/"alive_web_app.txt | sed 's/https\:\/\///' | sed 's/http\:\/\///' | sort | uniq > $c"/"$l"/"temp_to_remove
                #     comm  -3 $c"/"$l"/"temp_to_remove $c"/"$l"/"unique_ports  > $c"/"$l"/"alive_no_web_app.txt
                #     rm $c"/"$l"/"temp_to_remove
                # fi
            #fi
        #fi
    fi

done
