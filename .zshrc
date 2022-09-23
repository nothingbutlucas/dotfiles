#!/usr/bin/env zsh

CONFIG_DIR="$HOME/dotfiles/zshrc"

source ${CONFIG_DIR}/init.sh

FILES_STR=$(ls ${CONFIG_DIR})
FILES=($(echo $FILES_STR | tr '\n' ' '))

source ~/powerlevel10k/powerlevel10k.zsh-theme

for FILE in $FILES; do
    if [[ $FILE != "init.sh" ]]; then
        # echo "Sourcing $FILE"
        source ${CONFIG_DIR}/$FILE
    fi
done


[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

(( ! ${+functions[p10k-instant-prompt-finalize]} )) || p10k-instant-prompt-finalize

#(( ! ${+functions[p10k]} )) || p10k finalize
