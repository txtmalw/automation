#! /bin/bash



function enum_sub(){
  FILE=scan_results/$c/enum_sub.txt
  if [[ ! -f "$FILE" ]]; then
      echo "Sub Enum"
      ./SubEnum/subenum.sh -d $m  -o scan_results/$c/enum_sub.txt -p 
  fi
}

function resolve(){
  FILE=scan_results/$c/out_alive.txt
  if [[ ! -f "$FILE" || ! -s "$FILE" ]]; then
      echo "Resolve.sh"
      FILE2=scan_results/$c/enum_sub.txt
      ./resolve.sh scan_results/$c scan_results/$c/enum_sub.txt $exclude 
  fi
}

function httpx_check(){
  FILE=scan_results/$c/alive_http_probe_final.txt
  if [[ ! -f "$FILE" || ! -s "$FILE" ]]; then
    FILE_1="./scan_results/$c/alive_http_probe.txt"
    if [[ ! -f "$FILE_1" || ! -s "$FILE" ]]; then
    echo "httprobe"
    cat scan_results/$c/out_alive.txt | ~/go/bin/httprobe > scan_results/$c/alive_http_probe.txt 
    fi
    cat scan_results/$c/alive_http_probe.txt | grep -v '\bhttp\:.*\b443' > scan_results/$c/alive_http_probe_final.txt
  fi
}

function smuggling(){
  FILE="./scan_results/$c/smuggling.txt"
  if [[ ! -f "$FILE" ]]; then
    echo "http request smuggling" 
    ./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "Smuggling scan for $c "  --username "Notification Bot"  
    echo python3 ./http-request-smuggling/smuggle.py -urls scan_results/$c/alive_http_probe_final.txt 
    python3 ./http-request-smuggling/smuggle.py -urls scan_results/$c/alive_http_probe_final.txt 
    echo 1 > "./scan_results/$c/smuggling.txt"
  fi
}

function sniper_check(){
  FILE="./scan_results/$c/sniper.txt"
  if [[ ! -f "$FILE" ]]; then
    echo "sniper"
    echo ./Sn1per/sniper -f scan_results/$c/alive_http_probe_final.txt -m masswebscan -w "scan_results/$c" 
    ./Sn1per/sniper -f scan_results/$c/alive_http_probe_final.txt -m masswebscan -w "scan_results/$c" 
    echo ./Sn1per/sniper -f scan_results/$c/alive_http_probe_final.txt -m massvulnscan -w "scan_results/$c" 
    ./Sn1per/sniper -f scan_results/$c/alive_http_probe_final.txt -m massvulnscan -w "scan_results/$c" 
    echo 1 > "./scan_results/$c/sniper.txt"
  fi
}

function sudomain_takeover(){
  FILE="./scan_results/$c/takeover.txt"
  if [[ ! -f "$FILE" ]]; then
    echo "sub takeover" 
    #echo ~/go/bin/subjack -c /root/go/pkg/mod/github.com/haccer/subjack@v0.0.0-20201112041112-49c51e57deab/fingerprints.json -w scan_results/$c/alive_http_probe_final.txt -t 100 -timeout 30 -o $FILE -ssl &
    ~/go/bin/subjack -c /root/go/pkg/mod/github.com/haccer/subjack@v0.0.0-20201112041112-49c51e57deab/fingerprints.json -w scan_results/$c/alive_http_probe_final.txt -t 100 -timeout 30 -o $FILE -ssl 
  fi
}

function web_probe(){
  ./web_probe.sh -c "scan_results/$c" -m $l 
}

function url_and_data_retrieval(){
    ./url_and_data_retrieval.sh -c "scan_results/$c" -m $l 

}

function run_vuln_scan(){
  ./run_vuln_scan.sh -c "scan_results/$c" -m $l 

}

function osint(){
  ./osint.sh -c "scan_results/$c" -m $l 
}


#$c company_name 
#$m main_domain 

discord_url="https://discord.com/api/webhooks/1024983656525209671/YHIA3nhpyAwBO44qsei24RGQIWZQWamDL1_jHepXljHevVy07JibCnRl6GUIIfCE16Fe"



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
    enum_sub
    resolve
   
else
    echo "single domain scan"
    echo $s > scan_results/$c/out_alive.txt
fi


BURP_HOST=127.0.0.1
BURP_PORT=1338


# FILE_2="./scan_results/$c/end.txt"
# if [[ ! -f $FILE_2 ]];
# then 

  httpx_check
  #smuggling
 # sniper_check
  sudomain_takeover


for l in $(cat scan_results/$c/out_alive.txt)
    do
            ./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "Starting scan for $l "  --username "Notification Bot"  
            echo "web probe $l";
            web_probe
            echo "url_and_data_retrieval $l";
            url_and_data_retrieval
            echo "run_vuln_scan $l";
            run_vuln_scan
            python3 ./http-request-smuggling/raw_proxy.py  $l > "scan_results/$c/$l/smuggl_out.txt" 
            echo "osint $l";
            osint
            echo "report $l";
            ./report.sh -c "scan_results/$c" -m $l     
    done
# echo 1 > "scan_results/$c/end.txt"
# fi
exit 0;
