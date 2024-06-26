# Navigation

alias ..="cd .."
alias cd..="cd .."
alias c="batcat"
alias ls="lsd --hyperlink=auto --sort time"
alias g="git"
alias edit_aliases="cd ${HOME}/dotfiles/ && ls -la"
alias which_key="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'" # https://askubuntu.com/questions/411419/how-do-i-check-which-key-is-pressed
alias gdiff="git difftool --no-symlinks --dir-diff"

# Fast tty-clock configuration

alias ttyclock='tty-clock -c -C 6 -t -B'

# Security

alias reverse_shell_ps="ps aux | grep /bin/bash/-i"
alias block_incoming_ip="sudo iptables -A INPUT -s $1 -j DROP || echo 'Provide an IP address as argument'"
alias block_outgoing_ip="sudo iptables -A OUTPUT -d $1 -j DROP || echo 'Provide an IP address as argument'"
alias mouse_jiggler="while true; do xdotool mousemove_relative 1 1; sleep 1; xdotool mousemove_relative -- -1 -1; sleep 1; done"

# unetbootin

alias unetbootin='sudo QT_X11_NO_MITSHM=1 /usr/bin/unetbootin'

# Misc

alias is_shutdown_scheduled="cat /run/systemd/shutdown/scheduled | awk -F '=' '/USEC/{print $2}' | awk '{print int($1/1000000)}' | xargs -I{} date -d @{}"
alias day="date +%A-%d-%m-%y"
alias sound="play -n synth 0.15 sine 500"

# Clipboard

alias cb='flatpak run app.getclipboard.Clipboard'
