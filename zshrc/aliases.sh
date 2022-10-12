# Navigation

alias ..="cd .."
alias cd..="cd .."
alias c="bat"
alias ls="lsd"
alias g="git"
alias edit_aliases="cd ${HOME}/dotfiles/ && ls -la"

# Fast tty-clock configuration

alias ttyclock='tty-clock -c -C 6 -t -B'

# Security

alias reverse_shell_ps="ps aux | grep /bin/bash/-i"

# Music

alias music='cat ${HOME}/dotfiles/zshrc/music.sh | sed "s/=/ /g" | awk "{print \$2}"'
