#!/usr/bin/env bash

export $(gnome-keyring-daemon -r --components=pkcs11,secrets,ssh,gpg)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
git $1
exit 0
