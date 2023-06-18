#!/bin/bash

warp_status=$(warp-cli status | grep "Status" | awk '{print $3}')

if [[ $warp_status == "Disconnected." ]]; then
	echo ""
else
	echo -ne "  WARP"
fi
