# Navigation

alias ..="cd .."
alias cd..="cd .."
alias c="bat"
alias ls="lsd"
alias g="git"
alias edit_aliases="cd ${HOME}/dotfiles/ && ls -la"

# Fast tty-clock configuration

alias ttyclock='tty-clock -c -C 6 -t -B'

# Music

alias lofi='mpv --no-video https://youtu.be/jfKfPfyJRdk'
alias deadmau5='mpv --no-video https://youtu.be/0DJ-mEAEnrM'
alias ochentas='mpv --no-video https://youtu.be/e_Z1CawQIvo'
alias the_clash='mpv --no-video https://youtu.be/l0Q8z1w0KGY'
alias youtube_search='BROWSER=w3m ddgr -x -w youtube.com'

# Security

alias reverse_shell_ps="ps aux | grep /bin/bash/-i"
