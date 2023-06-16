#!/bin/bash

#../SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt
#../SecLists/Discovery/Web-Content/raft-medium-extensions-lowercase.txt
#../SecLists/Fuzzinf/special-chars.txt
#GOBIN=/home/$USER/go/bin/home/$USER/go/bin

while getopts 'u:p:m:f:o:' OPTION; do
  case "$OPTION" in
    u)
      uvalue="$OPTARG"
      #echo "url provided is $OPTARG"
      ;;
    p)
      pvalue="$OPTARG"
      #echo "proxy provided is $OPTARG"

      fuff_proxy=" -p $pvalue"
      

      ;;
    m)
    match=" -fw $OPTARG"
    #echo "match provided is $OPTARG"   

    ;;
    f)
    match2="-fw $OPTARG"
    #echo "match2 provided is $OPTARG"   

    ;;
    o)
    output="$OPTARG"
    #echo "output provided is $OPTARG"   

    ;;
    ?)
      echo "script usage: $(basename \$0) url [-p" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

list2="../SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt"
list21="../SecLists/Discovery/Web-Content/raft-medium-extensions-lowercase.txt"
list22="/root/snap/feroxbuster/common/content_discovery_all.txt"
list23="../SecLists/Discovery/Web-Content/raft-medium-files-lowercase.txt"
list3="../SecLists/Fuzzinf/special-chars.txt"

domain_and_port=$(echo $uvalue | sed 's/:\/\//_/' | sed 's/:/_/')
domain_clean=$(echo $uvalue | awk -F ':' '{print $2}' | sed 's/\/\///')



mkdir -p $output"/"$domain_and_port

#check ffuf

function sampleDiscovery(){

  FILE=$output"/"$domain_and_port"/out_1_urls.txt"
  if [[ ! -f "$FILE"  ]]; then
    #feroxbuster --url $line   --thorough --random-agent --redirects --rate-limit 3 -e -L 6m --auto-tune --auto-bail -k -o  $output"/"$domain_and_port"/out_1_urls.txt"
    echo "FILE DISCOVERY 1 $uvalue"
    feroxbuster --url $uvalue  --random-agent --redirects --rate-limit 3 -e -L 6 -w $list22  --auto-bail -k --silent $fuff_proxy >  $output"/"$domain_and_port"/out_1_urls.txt" &
    wait < <(jobs -p)

  fi
}



#check generic

FILE=$output"/"$domain_and_port/"final_urls_sorted_and_unique.txt"
if [[ ! -f "$FILE" ]]; then

#check gau

FILE=$output"/"$domain_and_port/urls_gau.txt
if [[ ! -f "$FILE" ]]; then

  echo "gau: $uvalue"
  echo $uvalue | ~/go/bin/gau | grep -Eo 'https?://([a-z0-9]+[.])*'$domain_clean'.*' > $output"/"$domain_and_port/urls_gau.txt
fi

#check hackrawler

FILE=$output"/"$domain_and_port/urls_hakrawler.txt
if [[ ! -f "$FILE" ]]; then

  echo "hakrawler: $uvalue"
  echo $uvalue | ~/go/bin/hakrawler -subs -u | grep -Eo 'https?://([a-z0-9]+[.])*'$domain_clean'.*' > $output"/"$domain_and_port/urls_hakrawler.txt
fi

#check waybackurls

FILE=$output"/"$domain_and_port/urls_waybackurls.txt
if [[ ! -f "$FILE" ]]; then

  echo "waybackurls: $uvalue"
  echo $uvalue | ~/go/bin/waybackurls | grep -Eo 'https?://([a-z0-9]+[.])*'$domain_clean'.*' > $output"/"$domain_and_port/urls_waybackurls.txt
fi

#check katana

FILE=$output"/"$domain_and_port/urls_katana.txt
if [[ ! -f "$FILE" ]]; then
  echo "katana: $uvalue"
  echo $uvalue | ~/go/bin/katana -jc -f qurl -d 5 -c 50 -kf robotstxt,sitemapxml -ef png,css,jpg,jpeg -silent -o $output"/"$domain_and_port/urls_katana.txt
fi

cat $output"/"$domain_and_port/urls* >  $output"/"$domain_and_port/final_urls.txt


FILE=$output"/"$domain_and_port"/out_1_urls.txt" 
if [[ -f "$FILE" ]]; then 

  cat $output"/"$domain_and_port"/out_1_urls.txt" | jq -r  '.results[] | select(.length != 0)  | .url  ' >> $output"/"$domain_and_port/final_urls.txt
fi

cat $output"/"$domain_and_port"/final_urls.txt" | sort | uniq > $output"/"$domain_and_port/"final_urls_sorted_and_unique.txt"


rm -rf $output"/"$domain_and_port"/url*"
rm -rf $output"/"$domain_and_port"/out_*_urls.txt" #forse da rivedere
 
fi
