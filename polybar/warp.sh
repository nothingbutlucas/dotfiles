#!/bin/bash

# Verify if warp-cli exists

if ! command -v warp-cli &>/dev/null; then
	echo ""
	exit
fi

warp_status=$(warp-cli status | grep "Status" | awk '{print $3}')

if [[ $warp_status == "Disconnected." ]]; then
	echo ""
else
	echo -ne "  WARP"
fi
