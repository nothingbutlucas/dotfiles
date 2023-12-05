# This bindkeys are declarated because the kitty terminal has compatibility problems with that keys

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

if [ "$(grep -q  Debian /etc/os-release)" ]; then
	bindkey '^R' fzf-history-widget
fi
