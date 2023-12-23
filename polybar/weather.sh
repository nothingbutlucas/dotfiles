#!/usr/bin/env bash

weather=$(curl -s "wttr.in/$CITY?m&format=%t+%C+☔%p&lang=es" || echo "No weather info available")

if [[ "$weather" == "Unknown"* ]]; then
	echo ""
else
	echo "$weather"

fi
