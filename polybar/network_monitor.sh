#!/bin/bash

awk '!/Unknown|Refreshing:|unknown|Adding|Ethernet/ {print $1}' /tmp/nethogs-output.txt | awk '!a[$0]++' | tail -1
