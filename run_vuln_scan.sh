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

folder="$c"



#GOBIN=/home/$USER/go/bin/home/$USER/go/bin

#sudo -u as nuclei -update 

#sudo -u as nuclei -ut

UT=krius


chmod -R 777 ./scan_results


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

for dom in $(cat $dest_file)
    do  
        echo "VULN SCAN $dom"
        FILE=$c"/"$dom"/alive_no_web_app.txt"
        if [[ -f "$FILE" ]]; then
            FILE=$c"/"$dom"/nuclei_output_general"
            if [[ ! -f "$FILE" ]]; then
                echo "VULN GENERAL $dom"
                timeout 4m ~/go/bin/nuclei -l $c"/"$dom"/alive_no_web_app.txt" -o  $c"/"$dom"/nuclei_output_general" -silent -rlm 30 -project-path $c"/"$dom  ;
            fi
        fi

        for l in $(cat $c"/"$dom"/alive_web_app.txt")
            do
                #domain=$(echo $l | awk -F '/' '{print $4}' | sed '0,/_/{s/_/\:\/\//}' | sed 's/_/:/')
                #domain2=$(echo $l | awk -F '/' '{print $4}')
                domain_and_port=$(echo $l | sed 's/:\/\//_/' | sed 's/:/_/')



                
                
                
                FILE_B="$c/$dom/$domain_and_port/final_urls_sorted_and_unique.txt"

               
                if [[ -f "$FILE_B" ]]; then
                    #echo "here $i"
                    # FILE=$c"/"$dom"/"$domain_and_port"/nuclei_output.md"
                    # if [[ ! -f "$FILE" ]]; then

                        
                            echo "VULN SINGLE $domain_and_port"
                            ./vulnerability_scan.sh -u $l  -o $c"/"$dom"/"$domain_and_port  -f "$FILE_B"  &
                      
                            wait  < <(jobs -p)

                        #fi
                    #fi
                fi
            done
       
    done