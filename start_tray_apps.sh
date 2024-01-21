#!/bin/bash -e

if [ $(pgrep -c solaar) -eq 0 ]; then
	solaar --window=hide &
	disown
fi

if [ $(pgrep -c opensnitch-ui) -eq 0 ]; then
  opensnitch-ui &
  disown
fi
