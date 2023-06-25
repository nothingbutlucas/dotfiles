#!/bin/bash

weather=$(curl -s "es.wttr.in/$CITY?format=%t+%C+☔%p" || echo "No weather info available")

if [[ "$weather" == "Unknown"* ]]; then
	echo ""
else
	echo "$weather"
fi
