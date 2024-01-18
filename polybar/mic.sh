#!/usr/bin/env bash

# Comprueba el estado del micrófono
state=$(amixer get Capture | grep -o '\[on\]' | head -n1)
vol=$(amixer get Capture | awk -F"[][]" '/Left:/ { print $2 }')
# vol=$(sox -d -V3 2>&1 | grep '^Volume:' | awk '{print $2}' | tr -dc '0-9')
# vol=$(arecord -d 1 -v monitor | od -An -td1)
# Imprime un carácter u otro dependiendo del estado del micrófono
if [[ $state == "[on]" ]]; then
  echo " $vol"
else
  echo " $vol"
fi
