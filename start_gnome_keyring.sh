#!/usr/bin/env bash

# eval $(/usr/bin/gnome-keyring-daemon --replace --components=gpg,pkcs11,secrets,ssh)
export $(gnome-keyring-daemon -r --components=pkcs11,secrets,ssh,gpg)
# dbus-update-activation-environment --systemd DISPLAY
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

exit 0
