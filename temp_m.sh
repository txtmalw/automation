#!/bin/bash
d=0

for l in $(cat /tmp/hackerone_data.json |  jq  '.[] | select((.offers_bounties | tostring) == "true") | .name' | tr -d "\""):
do
	c=$(echo $l | tr -d " " | tr -d "\""  | tr '&' '_' | tr '-' '_' )

	for  main_mobile_android in $(cat /tmp/hackerone_data.json | jq  -r '.[] |  select(.name == "'$l'") | .targets.in_scope[] | select(.asset_type == "GOOGLE_PLAY_APP_ID" ) | .asset_identifier');
	 do 

	 	if [[ $d -le 1 ]]; then

	 	echo ./test_mobile.sh  -c "$c" -m $main_mobile_android 
		./test_mobile.sh  -c "$c" -m "$main_mobile_android"  &

		d=$((d+1))
		else
			wait < <(jobs -p)
			d=1

				echo ./test_mobile.sh  -c "$c_$m" -m $main_mobile_android 
		./test_mobile.sh  -c "$c" -m "$main_mobile_android"  &

		fi
	 	

	 done
done
