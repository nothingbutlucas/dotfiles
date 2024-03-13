#!/bin/bash

# Set Colors

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)
purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
orange=$(tput setaf 3)
blue=$(tput setaf 38)

# Headers and  Logging

e_header() {
  half_columns=$(($(tput cols) / 2))
  args=$*
  string_length=${#args}
  n_of_characters=$(( half_columns - $((string_length / 2)) - 2))
  equals_line=$(printf '%0.s=' $(seq 1 ${n_of_characters}))
  printf "\n${bold}${purple}${equals_line} %s ${equals_line}${reset}\n" "$@"
}
e_arrow() { printf "➜ %s\n" "$*"
}
e_success() { printf "${green}✔ %s${reset}\n" "$*"
}
e_error() { printf "${red}✖ %s${reset}\n" "$*"
}
e_warning() { printf "${orange}➜ %s${reset}\n" "$*"
}
e_underline() { printf "${underline}${bold}%s${reset}\n" "$*"
}
e_bold() { printf "${bold}%s${reset}\n" "$*"
}
e_note() { printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$*"
}
