#!/usr/bin/env bash

eval $(/usr/bin/gnome-keyring-daemon -s --components=gpg,pkcs11,secrets,ssh)
export $(gnome-keyring-daemon -r --components=pkcs11,secrets,ssh,gpg)
dbus-update-activation-environment --systemd DISPLAY

exit 0
