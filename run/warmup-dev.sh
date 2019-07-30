#!/usr/bin/env bash

domains=(
    https://localhost
)

function get {
wget -q --no-check-certificate $1/sitemap.xml --no-cache -O - | egrep -o "$1[^<]+" | while read subsite;
do
    subsite=$(echo $subsite | sed 's/\&amp;/\&/g')
    echo --- Reading Sub: $subsite ---
	wget -q --no-check-certificate $subsite --no-cache -O - | egrep -o "$1[^<]+" | while read line;
	do
        line=$(echo $line | sed 's/\&amp;/\&/g')
        time curl -sL -A 'Cache Warmer' $line > /dev/null 2>&1
        echo $line:
	done
	echo --- FINISHED reading sub-sitemap: $subsite: ---
done
}

for domain in "${domains[@]}" ; do
    echo "$domain"
    get $domain
done