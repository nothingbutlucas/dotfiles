#!/usr/bin/env bash

# Verify if a vpn through wireguard is active and display the icon

wireguard_status=$(ip addr | grep "wg")

if [[ "$wireguard_status" == "" ]]; then
  echo "󱐝"
else
  echo "󰆧"
fi

