# Navigation

alias ..="cd .."
alias cd..="cd .."
alias c="bat"
alias ls="lsd"
alias g="git"
alias edit_aliases="cd ${HOME}/dotfiles/ && ls -la"
alias which_key="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'" # https://askubuntu.com/questions/411419/how-do-i-check-which-key-is-pressed

# Fast tty-clock configuration

alias ttyclock='tty-clock -c -C 6 -t -B'

# Security

alias reverse_shell_ps="ps aux | grep /bin/bash/-i"
alias block_incoming_ip="sudo iptables -A INPUT -s $1 -j DROP || echo 'Provide an IP address as argument'"
alias block_outgoing_ip="sudo iptables -A OUTPUT -d $1 -j DROP || echo 'Provide an IP address as argument'"
alias mouse_jiggler="while true; do xdotool mousemove_relative 1 1; sleep 1; xdotool mousemove_relative -- -1 -1; sleep 1; done"

# Music

alias music='cat ${HOME}/dotfiles/zshrc/music.sh | sed "s/=/ /g" | awk "{print \$2}"'

# unetbootin

alias unetbootin='sudo QT_X11_NO_MITSHM=1 /usr/bin/unetbootin'
