#!/usr/bin/env bash

FILE=/tmp/weather.txt

if [[ ! -f $FILE ]] || [[ $(find $FILE -mmin +60 -print -quit) ]]; then
 weather=$(curl --connect-timeout 2 -s -w "%{http_code}" "wttr.in/$CITY?format=%c%t" || echo "No weather info available")
 http_status=${weather: -3}
 weather=${weather::-3}
 if [[ $http_status == "200" ]]; then
   echo "${weather/+/}" | cut -c 1-26  > $FILE
 fi
fi

weather=$(cat $FILE || echo "No weather info available")

echo " $weather "
