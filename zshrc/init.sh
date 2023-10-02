zmodload zsh/zprof

# Vim mode

set -o vi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc. Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

# Use modern completion system

autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

source /usr/share/doc/fzf/examples/key-bindings.zsh

source /usr/share/doc/fzf/examples/completion.zsh

PATH=$HOME/bin:/usr/local/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin:$HOME/.config/nvim/:$HOME/.cargo/bin/:$HOME/.local/bin:/usr/local/lib/:$HOME/go/bin/:$PATH

xrdb ~/.Xdefaults

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export LD_LIBRARY_PATH=/usr/local/lib/
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
export OPENSCADPATH=$HOME/.local/share/OpenSCAD/libraries/

# clipbard variables

export CLIPBOARD_NOAUDIO=1
export CLIPBOARD_EDITOR=nvim
export CLIPBOARD_THEME=green

# gum variables

nothing_but_lucas_green="#BFEA00"

export BORDER="rounded"
export MARGIN="1 1"
export PADDING="1 1"
export ALIGN="center"
export BOLD=1
export BORDER_FOREGROUND=$nothing_but_lucas_green
export GUM_CHOOSE_CURSOR="~> "
export GUM_CHOOSE_CURSOR_PREFIX="[ ] "
export GUM_CHOOSE_SELECTED_PREFIX="[*] "
export GUM_CHOOSE_UNSELECTED_PREFIX="[ ] "
export GUM_CHOOSE_CURSOR_FOREGROUND=$nothing_but_lucas_green
export GUM_CHOOSE_SELECTED_FOREGROUND=$nothing_but_lucas_green
export GUM_SPIN_SPINNER="pulse"
export GUM_SPIN_SPINNER_FOREGROUND=$nothing_but_lucas_green
export GUM_CONFIRM_SELECTED_BACKGROUND=$nothing_but_lucas_green
export GUM_TABLE_HEADER_FOREGROUND=$nothing_but_lucas_green
export GUM_CHOOSE_HEADER_FOREGROUND=$nothing_but_lucas_green

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
