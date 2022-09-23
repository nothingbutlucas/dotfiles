#!/usr/bin/env bash

CONFIG_DIR="$HOME/dotfiles/bashrc"

source ${CONFIG_DIR}/init.sh

FILES_STR=$(ls ${CONFIG_DIR})
FILES=($(echo $FILES_STR | tr '\n' ' '))

for FILE in $FILES; do
    if [[ $FILE != "init.sh" ]]; then
        # echo "Sourcing $FILE"
        source ${CONFIG_DIR}/$FILE
    fi
done

PS1="$USER->\W/\$: "
