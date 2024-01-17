#!/usr/bin/env bash

FILE=/tmp/weather.txt

if [[ ! -f $FILE ]] || [[ $(find $FILE -mmin +60 -print -quit) ]]; then
 weather=$(curl -s -w "%{http_code}" "wttr.in/$CITY?m&format=%t+%C+☔%p&lang=es" || echo "No weather info available")
 http_status=${weather: -3}
 weather=${weather::-3}
 if [[ $http_status == "200" ]]; then
   echo "$weather" > $FILE
 fi
fi

weather=$(cat $FILE || echo "No weather info available")

if [[ "$weather" == "Unknown"* ]]; then
	echo ""
else
	echo " $weather "
fi

