#!/bin/bash

cores=$(nproc)

values=( $(yad --form --center --width=600 --title="Start Judgehosts" --separator=' ' \
        --button="gtk-ok:0" --button="gtk-close:1" \
        --field="Amount":NUM \
            "$((cores / 2))!1..$cores!1!0" \
	--field="DOMserver baseurl" \
	    'https://dj.chipcie.ch.tudelft.nl/' \
	--field="Password":H \
	    '' \
	--field="Container" \
	    'ghcr.io/wisvch/domjudge-packaging/judgehost' \
	--field="Version" \
	    '8.2.0' \
	    ) )

if [ $? -eq 0 ]; then
    amount="${values[0]}"
    base_url="${values[1]}"
    password="${values[2]}"
    container="${values[3]}"
    version="${values[4]}"

    ip=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    hostname="judgedaemon-${ip//./_}"


   for (( c=0; c<$amount; c++ )); do
	   env JUDGEDAEMON_PASSWORD=$password gnome-terminal -- ~/chipcie-startup-scripts/start-judgehost.sh --domserver-baseurl "$base_url" --hostname "$hostname" --container "$container" --version "$version" --no-detach $((($c + 1) % $cores))
   done

   gnome-terminal -- htop

fi
