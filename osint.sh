#! /bin/bash

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
      echo "script usage: $(basename \$0) url [-p" >2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"


i=0
UT=krius
folder="$c"

#GOBIN=/home/$USER/go/bin/home/$USER/go/bin

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
        
        FILE=$c"/"$dom"/osint_google.txt"
        if [[ ! -f "$FILE" ]]; then
            if [[ $i -le 3 ]]; then 

                proxy_https_random_int=$(shuf -n 1 /tmp/goodproxies.txt)
                ggdorker_proxy=" -x https://$proxy_https_random_int"
                                   
                 python3 ./GgDorker/GgDorker.py --silent -t "site:$dom" -n 1 -d ./GgDorker/dorks.txt -o $c"/"$dom"/osint_google.txt" $ggdorker_proxy
                #./crawler.sh 
                i=$((i+1))
            else
                proxy_https_random_int=$(shuf -n 1 /tmp/goodproxies.txt)
                ggdorker_proxy=" -x https://$proxy_https_random_int"
               # wait < <(jobs -p)
                i=1
                 python3 ./GgDorker/GgDorker.py --silent -t "site:$dom" -n 1 -d ./GgDorker/dorks.txt -o $c"/"$dom"/osint_google.txt" $ggdorker_proxy
            fi      
        fi


        FILE=$c"/"$dom"/osint_general.txt"
        if [[ ! -f "$FILE" ]]; then
            if [[ $i -le 3 ]]; then   
                proxy_https_random_int=$(shuf -n 1 /tmp/goodproxies.txt)
                ggdorker_proxy=" -x https://$proxy_https_random_int"                      
                 python3 ./GgDorker/GgDorker.py --silent -t "$dom" -n 1 -d ./GgDorker/OSINT_dorks.txt -o $c"/"$dom"/osint_general.txt" $ggdorker_proxy
                #./crawler.sh 
                i=$((i+1))
            else
                 proxy_https_random_int=$(shuf -n 1 /tmp/goodproxies.txt)
                ggdorker_proxy=" -x https://$proxy_https_random_int"
               # wait
                i=1
                 python3 ./GgDorker/GgDorker.py --silent -t "$dom" -n 1 -d ./GgDorker/OSINT_dorks.txt -o $c"/"$dom"/osint_general.txt" $ggdorker_proxy
            fi      
        fi


        # FILE=$c"/"$dom"/go_dork_google.txt"
        # if [[ ! -f "$FILE" ]]; then
        #     if [[ $i -le 3 ]]; then 
        #         for line in $(cat ./GgDorker/dorks.txt)
        #         do
        #             ~/go/bin/go-dork  -s -e google -q "site:$dom $line" >> $c"/"$dom"/go_dork_google.txt" 
        #             sleep 2;
        #         done;                        
        #         #./crawler.sh 
        #         i=$((i+1))
        #     else
        #         wait
        #         i=1
        #         for line in $(cat ./GgDorker/dorks.txt)
        #         do
        #             ~/go/bin/go-dork  -s -e google -q "site:$dom $line" >> $c"/"$dom"/go_dork_google.txt" 
        #             sleep 2;
        #         done               
        #     fi      
        #fi


        FILE=$c"/"$dom"/go_dork_bing.txt"
        if [[ ! -f "$FILE" ]]; then
            if [[ $i -le 3 ]]; then 
                for line in $(cat ./GgDorker/dorks.txt); 
                do
                    proxy_https_random_int=$(shuf -n 1 /tmp/goodproxies.txt)
                    go_dork_proxy=" -x https://$proxy_https_random_int"
                   ~/go/bin/go-dork  -s -e bing -q "site:$dom $line" $go_dork_proxy >> $c"/"$dom"/go_dork_bing.txt" $go_dork_proxy
                   # sleep 2;
                done                      
                #./crawler.sh 
                i=$((i+1))
            else
                #wait
                i=1
                for line in $(cat ./GgDorker/dorks.txt); 
                do
                    proxy_https_random_int=$(shuf -n 1 /tmp/goodproxies.txt)
                    go_dork_proxy=" -x https://$proxy_https_random_int"
                   ~/go/bin/go-dork  -s -e bing -q "site:$dom $line" $go_dork_proxy >> $c"/"$dom"/go_dork_bing.txt" $go_dork_proxy
                    #sleep 2;
                done            
            fi      
        fi

        FILE=$c"/"$dom"/go_dork_shodan.txt"
        if [[ ! -f "$FILE" ]]; then
            if [[ $i -le 3 ]]; then 
                     proxy_https_random_int=$(shuf -n 1 /tmp/goodproxies.txt)
                    go_dork_proxy=" -x https://$proxy_https_random_int"
                    ~/go/bin/go-dork  -s -e shodan -q "hostname:$dom " >> $c"/"$dom"/go_dork_shodan.txt"  $go_dork_proxy
                               
                #./crawler.sh 
                i=$((i+1))
            else
               # wait
                i=1
                proxy_https_random_int=$(shuf -n 1 /tmp/goodproxies.txt)
                    go_dork_proxy=" -x https://$proxy_https_random_int"
                    ~/go/bin/go-dork  -s -e shodan -q "hostname:$dom " >> $c"/"$dom"/go_dork_shodan.txt"  $go_dork_proxy
                             
            fi      
        fi


        FILE=$c"/"$dom"/go_dork_duck.txt"
        if [[ ! -f "$FILE" ]]; then
            if [[ $i -le 3 ]]; then 
                for line in $(cat ./GgDorker/dorks.txt); 
                do
                proxy_https_random_int=$(shuf -n 1 /tmp/goodproxies.txt)
                    go_dork_proxy=" -x https://$proxy_https_random_int"
                    ~/go/bin/go-dork  -s -e duck -q "site:$dom $line" $go_dork_proxy >> $c"/"$dom"/go_dork_duck.txt"  $go_dork_proxy
                    #sleep 2;
                done;                        
                #./crawler.sh 
                i=$((i+1))
            else
                #wait
                i=1
                for line in $(cat ./GgDorker/dorks.txt); 
                do
                    proxy_https_random_int=$(shuf -n 1 /tmp/goodproxies.txt)
                    go_dork_proxy=" -x https://$proxy_https_random_int"
                   ~/go/bin/go-dork  -s -e duck -q "site:$dom $line" $go_dork_proxy >> $c"/"$dom"/go_dork_duck.txt"  $go_dork_proxy
                   # sleep 2;
                done              
            fi      
        fi


    done
