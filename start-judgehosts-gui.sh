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
	    '8.1.2' \
	    ) )

if [ $? -eq 0 ]; then
    amount="${values[0]}"
    base_url="${values[1]}"
    password="${values[2]}"
    container="${values[3]}"
    version="${values[4]}"


   for (( c=0; c<$amount; c++ )); do
      echo "amount:$amount base_url:$base_url password:$password container:$container version:$version"
      env JUDGEDAEMON_PASSWORD=$password gnome-terminal -- ~/chipcie-startup-scripts/start-judgehost.sh --domserver-baseurl $base_url --container $container --version $version --no-detach $c
   done

   gnome-terminal -- htop

fi
