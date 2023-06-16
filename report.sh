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

        rm $c/$dom/report_general.md;

        touch $c/$dom/report_general.md;

        echo "Report of $dom" >> $c/$dom/report_general.md
        echo "">>  $c/$dom/report_general.md
        echo "Ports identified" >> $c/$dom/report_general.md
        cat  $c"/"$dom"/"unique_ports >> $c/$dom/report_general.md  2>&1
        echo "">>  $c/$dom/report_general.md
        echo "Nmap out" >> $c/$dom/report_general.md
        cat $c"/"$dom"/"out_nmap_top_1000_ports_nmap.nmap >> $c/$dom/report_general.md  2>&1
        echo "">>  $c/$dom/report_general.md
        echo "Alive No Web App"  >> $c/$dom/report_general.md
        cat $c"/"$dom"/"alive_no_web_app.txt >> $c/$dom/report_general.md  2>&1
        echo "">>  $c/$dom/report_general.md
        echo "Alive Web App"  >> $c/$dom/report_general.md
        cat $c"/"$dom"/"alive_web_app.txt>> $c/$dom/report_general.md  2>&1
        echo "">>  $c/$dom/report_general.md
        echo "Osint"  >> $c/$dom/report_general.md
        cat $c"/"$dom"/"osint_* >> $c/$dom/report_general.md  2>&1
        echo "">>  $c/$dom/report_general.md
        echo "Nuclei Output General"  >> $c/$dom/report_general.md
        cat $c"/"$dom"/"nuclei_output_general >> $c/$dom/report_general.md  2>&1
        echo "" >> $c/$dom/report_general.md
        echo "Smuggling General"  >> $c/$dom/report_general.md
        cat $c"/"$dom"/smuggl_out.txt" >> $c/$dom/report_general.md  2>&1
        echo "" >> $c/$dom/report_general.md
        
        #echo $dom
        FILE=$c"/"$dom"/alive_web_app.txt"
        if [[ -f "$FILE" ]]; then
            for l in  $( cat $c"/"$dom"/alive_web_app.txt");
                do                    
                    domain_and_port=$(echo $l | sed 's/:\/\//_/' | sed 's/:/_/')
                    #echo $domain
                    echo "">>  $c/$dom/report_general.md
                    echo "Report of $l"  >> $c/$dom/report_general.md
                    echo "">>  $c/$dom/report_general.md
                    echo "Nuclei Output "  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/"nuclei_output.md  >> $c/$dom/report_general.md  2>&1
                    echo "">>  $c/$dom/report_general.md
                    echo "Burp Suite Output "  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/"unique_burp.md  >> $c/$dom/report_general.md  2>&1
                    echo "">>  $c/$dom/report_general.md
                    echo "Dalfox Output "  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/"dalfox_output.md  >> $c/$dom/report_general.md  2>&1
                    echo "">>  $c/$dom/report_general.md
                    echo "SQLmap Output "  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/"sqlmap.md  >> $c/$dom/report_general.md  2>&1
                    echo "">>  $c/$dom/report_general.md
                    echo "DNS Recon Output "  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/"dnsrecon_output  >> $c/$dom/report_general.md  2>&1
                    echo "">>  $c/$dom/report_general.md
                    echo "URLs Output "  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/"final_urls_sorted_and_unique.txt >> $c/$dom/report_general.md  2>&1
                    echo "">>  $c/$dom/report_general.md
                    
                    echo "GF Output "  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/debug_logic_urls.txt" >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/idor_urls.txt"  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/img-traversal_urls.txt" >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/interestingEXT_urls.txt" >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/interestingparams_urls.txt" >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/interestingsubs_urls.txt" >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/jsvar_urls.txt" >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/lfi_urls.txt"  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/rce_urls.txt" >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/redirect_urls.txt"  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/sqli_urls.txt"  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/ssrf_urls.txt"  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/ssti_urls.txt"  >> $c/$dom/report_general.md
                    cat $c"/"$dom"/"$domain_and_port"/gf/xss_urls.txt" >> $c/$dom/report_general.md
                    
                    echo "">>  $c/$dom/report_general.md
                    
                    

                done
                
        fi
        echo "END" >> $c/$dom/report_general.md

        discord_url="https://discord.com/api/webhooks/1024983656525209671/YHIA3nhpyAwBO44qsei24RGQIWZQWamDL1_jHepXljHevVy07JibCnRl6GUIIfCE16Fe"


        size=$(wc -c  $c/$dom/report_general.md | awk '{print $1}')
        size_compare=$((106 + $(echo $dom | wc -c  )))
        if [[ $size -gt $size_compare ]]; then


        ./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --file $c/$dom/report_general.md  --username "Notification Bot" --text "Report of $dom "

        fi
        #sleep 5;
    done