#! /bin/bash


#$c company_name 
#$m main_domain 

discord_url="https://discord.com/api/webhooks/1024983656525209671/YHIA3nhpyAwBO44qsei24RGQIWZQWamDL1_jHepXljHevVy07JibCnRl6GUIIfCE16Fe"

#GOBIN=/home/$USER/go/bin/home/$USER/go/bin

exclude=''

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
    e)
      exclude="$OPTARG"
      echo "exclude domains are $OPTARG"
      ;;
    ?)
      echo "script usage: $(basename \$0) url [-p" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

mkdir -p scan_results



mkdir -p scan_results/$c


chmod -R +777 scan_results/$c


if [[ -z "$s" ]]; then
    echo "No specific domain supplied"
    
    FILE=scan_results/$c/enum_sub.txt
    #rm $FILE #force the subenum
    if [[ ! -f "$FILE" ]]; then
        echo "Sub Enum"
        ./SubEnum/subenum.sh -d $m  -o scan_results/$c/enum_sub.txt -p &

       wait < <(jobs -p)
    fi



    #rm resolved-* 2>&1 /dev/null

    #$domain-$(date +'%Y-%m-%d').txt
    #verrà risolta

    FILE=scan_results/$c/out_alive.txt
    #rm $FILE
    if [[ ! -f "$FILE" || ! -s "$FILE" ]]; then
        echo "Resolve.sh"
        FILE2=scan_results/$c/enum_sub.txt
        #rm $FILE #force the subenum
        # if [[ ! -f "$FILE2" ]]; then
        #   echo $m > scan_results/$c/out_alive.txt
        # fi
        ./resolve.sh scan_results/$c scan_results/$c/enum_sub.txt $exclude &

       wait < <(jobs -p)
    fi
else
    echo "single domain scan"
    echo $s > scan_results/$c/out_alive.txt
fi


BURP_HOST=127.0.0.1
BURP_PORT=1338

#hunt for http request smuggling
FILE_2="./scan_results/$c/end.txt"
if [[ ! -f $FILE_2 ]];
then 
FILE=scan_results/$c/alive_http_probe_final.txt

if [[ ! -f "$FILE" || ! -s "$FILE" ]]; then




#for l in $(cat scan_results/dell/alive_http_probe_final.txt); do curl -w '%{time_total}\n' $l -m 2 -o /dev/null -s; done;
FILE="./scan_results/$c/alive_http_probe.txt"

if [[ ! -f "$FILE" ]]; then
echo "httprobe"
cat scan_results/$c/out_alive.txt | ~/go/bin/httprobe > scan_results/$c/alive_http_probe.txt 
fi
cat scan_results/$c/alive_http_probe.txt | grep -v '\bhttp\:.*\b443' > scan_results/$c/alive_http_probe_final.txt






# echo "start burp"

# sudo -u as /usr/lib/jvm/java-11-openjdk-amd64/bin/java -Djava.awt.headless=true --illegal-access=permit -Dfile.encoding=utf-8 -javaagent:/opt/Burp.Suite.Professional.2020.9.2/BurpSuiteLoader_v2020.9.2.jar -noverify -jar /opt/Burp.Suite.Professional.2020.9.2/burpsuite_pro_v2020.9.2.jar --project-file=scan_results/$c/file_burp.burp --unpause-spider-and-scanner --user-config-file=./HTTPRS.json 2>&1 /dev/null &

# last_pid=$!

# echo "sleep 15"
# sleep 15;

# echo "smuggler"
# cat scan_results/$c/alive_http_probe_final.txt | python3 ./../smuggler/smuggler.py -l scan_results/$c/smuggler &

FILE="./scan_results/$c/smuggling.txt"

if [[ ! -f "$FILE" ]]; then
echo "http request smuggling" 
./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "Smuggling scan for $c "  --username "Notification Bot"  &
echo python3 ./http-request-smuggling/smuggle.py -urls scan_results/$c/alive_http_probe_final.txt &
python3 ./http-request-smuggling/smuggle.py -urls scan_results/$c/alive_http_probe_final.txt 

echo 1 > "./scan_results/$c/smuggling.txt"
fi


FILE="./scan_results/$c/sniper.txt"
if [[ ! -f "$FILE" ]]; then
echo "sniper"

echo ./Sn1per/sniper -f scan_results/$c/alive_http_probe_final.txt -m masswebscan -w "scan_results/$c" &
./Sn1per/sniper -f scan_results/$c/alive_http_probe_final.txt -m masswebscan -w "scan_results/$c" 

echo ./Sn1per/sniper -f scan_results/$c/alive_http_probe_final.txt -m massvulnscan -w "scan_results/$c" &
./Sn1per/sniper -f scan_results/$c/alive_http_probe_final.txt -m massvulnscan -w "scan_results/$c" 

echo 1 > "./scan_results/$c/sniper.txt"
fi

fi
wait < <(jobs -p)


FILE="./scan_results/$c/takeover.txt"

if [[ ! -f "$FILE" ]]; then
echo "sub takeover" 
echo ~/go/bin/subjack -c /root/go/pkg/mod/github.com/haccer/subjack@v0.0.0-20201112041112-49c51e57deab/fingerprints.json -w scan_results/$c/alive_http_probe_final.txt -t 100 -timeout 30 -o $FILE -ssl &

~/go/bin/subjack -c /root/go/pkg/mod/github.com/haccer/subjack@v0.0.0-20201112041112-49c51e57deab/fingerprints.json -w scan_results/$c/alive_http_probe_final.txt -t 100 -timeout 30 -o $FILE -ssl 
wait < <(jobs -p)
fi



# cc=0

# for l in $(cat scan_results/$c/out_alive.txt)

#     do
        
#           if [[ $cc -le 1 ]]; then
#            ./osint.sh -c "scan_results/$c" -m $l &
#           	cc=$((cc+1))
#           else
#             wait < <(jobs -p)
#             cc=1
#              ./osint.sh -c "scan_results/$c" -m $l &
#           fi
#                         #echo "report $l";

# #            ./report.sh -c "scan_results/$c" -m $l &
#            # wait < <(jobs -p)
#             #sleep 3 
        
#     done

i=0

echo "test on "
cat scan_results/$c/out_alive.txt

for l in $(cat scan_results/$c/out_alive.txt)

    do
    if [[ $i -le 1 ]]; then
            ./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "Starting scan for $l "  --username "Notification Bot"  &

            # echo "port scanning $l";
            # ./port_scanning.sh scan_results/$c $l & 
            ## wait < <(jobs -p)
            echo "web probe $l";
            #./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "web probe $l"  --username "Notification Bot"  &


            ./web_probe.sh -c "scan_results/$c" -m $l &
            wait < <(jobs -p)
            echo "url_and_data_retrieval $l";
           # ./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "url_and_data_retrieval $l"  --username "Notification Bot"  &


            ./url_and_data_retrieval.sh -c "scan_results/$c" -m $l &
           wait < <(jobs -p) 
            echo "run_vuln_scan $l";
            #./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "run_vuln_scan $l"  --username "Notification Bot"  &

            ./run_vuln_scan.sh -c "scan_results/$c" -m $l 
           wait < <(jobs -p)
            #./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "smuggle $l"  --username "Notification Bot"  &

            python3 ./http-request-smuggling/raw_proxy.py  $l > "scan_results/$c/$l/smuggl_out.txt" &

       

            echo "report $l";
            #./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "report $l"  --username "Notification Bot"  &
            
            # ./report.sh -c "scan_results/$c" -m $l &
            # wait < <(jobs -p)
            #./osint.sh -c "scan_results/$c" -m $l &
             wait < <(jobs -p)
            # ./report.sh -c "scan_results/$c" -m $l &
            # wait < <(jobs -p)
    	i=$((i+1))
		else
			wait < <(jobs -p)
			i=1

      ./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "Starting scan for $l "  --username "Notification Bot"  &

            # echo "port scanning $l";
            # ./port_scanning.sh scan_results/$c $l & 
            ## wait < <(jobs -p)
            echo "web probe $l";
            #./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "web probe $l"  --username "Notification Bot"  &


            ./web_probe.sh -c "scan_results/$c" -m $l &
            wait < <(jobs -p)
            echo "url_and_data_retrieval $l";
            #./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "url_and_data_retrieval $l"  --username "Notification Bot"  &


            ./url_and_data_retrieval.sh -c "scan_results/$c" -m $l &
           wait < <(jobs -p) 
            echo "run_vuln_scan $l";
            #./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "run_vuln_scan $l"  --username "Notification Bot"  &

            ./run_vuln_scan.sh -c "scan_results/$c" -m $l 
           wait < <(jobs -p)
            #./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "smuggle $l"  --username "Notification Bot"  &

            python3 ./http-request-smuggling/raw_proxy.py  $l > "scan_results/$c/$l/smuggl_out.txt" &

           wait < <(jobs -p)

            echo "report $l";
            #./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "report $l"  --username "Notification Bot"  &

            # ./report.sh -c "scan_results/$c" -m $l &
            # wait < <(jobs -p)
            #./osint.sh -c "scan_results/$c" -m $l &
             wait < <(jobs -p)
            # ./report.sh -c "scan_results/$c" -m $l &
            # wait < <(jobs -p)
    fi 
            #echo "osint $l";

            # ./osint.sh "scan_results/$c" $l &
            ## wait < <(jobs -p)
            #echo "report $l";

            # ./report.sh "scan_results/$c" $l &
            ## wait < <(jobs -p)
            # sleep 3 
        
    done


echo 1 > "scan_results/$c/end.txt"

fi
exit 0;