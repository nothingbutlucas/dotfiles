#!/bin/bash

timeout --preserve-status --kill-after=1 2 radeontop -d - | awk '{print $27}' | grep "%" | sort -u | awk -F'.' '{print $1 "%"}'
