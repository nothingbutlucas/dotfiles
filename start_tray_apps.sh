#!/bin/bash -e

if [ $(ps aux | grep $USER | grep solaar | wc -l) -eq 1 ]; then
	solaar --window=hide &
	disown
fi

if [ $(ps aux | grep $USER | grep copyq | wc -l) -eq 1 ]; then
	copyq &
	disown
fi

if [ $(ps aux | grep $USER | grep openrgb | wc -l) -eq 1 ]; then
	openrgb --startminimized --profile angry &
	disown
fi
