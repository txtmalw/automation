#! /bin/bash


#$c company_name 
#$m main_domain 


discord_url="https://discord.com/api/webhooks/1081486737710272562/-G6c6cTgkTivlzhh-TqcfHCAMMij5r7IIK9gU3YcYwKx3OsEsnKIzDe8EwGRDCuYNXTd"

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
mkdir -p scan_results/$c/mobile


chmod -R +777 scan_results/$c/mobile

FILE="./scan_results/$c/mobile/$m.apk" 

./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "mobile scan for $m " --username "Notification Bot"  &

r=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo)

file_out=$(file $FILE )

if [[ ! $file_out == *"Zip archive data"* ]]; then
rm $FILE
fi

if [[ ! -f $FILE ]]; then 


proxy_https_random_int=$(shuf -n 1 /tmp/goodproxies.txt)
curl_proxy=" -x https://$proxy_https_random_int"


timeout 6m curl https://d.apkpure.com/b/APK/$m?version=latest -H "User-Agent: $r" -L --output "./scan_results/$c/mobile/$m.apk" #$curl_proxy


sleep 120;

FILE=$(pwd)"/scan_results/$c/mobile/$m.apkreport.pdf" 
size=$(wc -c  $FILE | awk '{print $1}')

if [[ ! -f $FILE || $size -lt 31 ]]; then 
rm $FILE
python3 ./mobile/rest_api.py  $(pwd)"/scan_results/$c/mobile/$m.apk" $( echo $MOBSF_API_KEY)

fi


fi

wait < <(jobs -p)

size=$(wc -c  $FILE | awk '{print $1}')
if [[ $size -gt "30" ]]; then

./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "MobSF output of $m " --file $(pwd)"/scan_results/$c/mobile/$m.apkreport.pdf" --username "Notification Bot"  &

./discord.sh-1.6.1/discord.sh --webhook-url=$discord_url --text "APK of $m " --file $(pwd)"/scan_results/$c/mobile/$m.apk" --username "Notification Bot"  &

else
  rm "./scan_results/$c/mobile/$m.apk"
fi
