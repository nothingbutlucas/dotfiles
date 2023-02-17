#!/usr/bin/bash

grey=$(tput setaf 8)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
red=$(tput setaf 1)
nc=$(tput sgr0)

error_logs=$(pwd)/error_logs.log
dotfiles=(.bashrc .zshrc .tmux.conf .gitconfig .gitignore .Xdefaults rc.lua .picom .ideavimrc)

quiet=0
package="none"

trap ctrl_c INT

function ctrl_c() {
    salir
}

function bruce_banner(){
    echo -e ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
    sleep 0.05
    echo -e "::          .::            .::      .::    .::                   ::"
    sleep 0.05
    echo -e "::          .::            .::    .:    .: .::                   ::"
    sleep 0.05
    echo -e "::          .::   .::    .:.: .:.:.: .:    .::   .::     .::::   ::"
    sleep 0.05
    echo -e "::      .:: .:: .::  .::   .::    .::  .:: .:: .:   .:: .::      ::"
    sleep 0.05
    echo -e "::     .:   .::.::    .::  .::    .::  .:: .::.::::: .::  .:::   ::"
    sleep 0.05
    echo -e "::     .:   .:: .::  .::   .::    .::  .:: .::.:            .::  ::"
    sleep 0.05
    echo -e "::  .:: .:: .::   .::       .::   .::  .::.:::  .::::   .:: .::  ::"
    sleep 0.05
    echo -e ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
    echo -e "\n"
}

function is_installed(){
  program=$1
  echo -e "${green}[+]${nc} Comprobando si tienes instalado ${program}..."
  sleep 0.05
  echo -e "${grey}$ command -v ${program} ${nc}"
  sleep 0.05
  if command -v "${program}" 1>/dev/null 2>>"${error_logs}"; then
      echo -e "${green}[+]${nc} ${program} está instalado"
      return 0
  else
      echo -e "${red}[!]${nc} ${program} no está instalado"
      return 1
  fi
}

function install(){
  program=$1
  if ! is_installed "${program}"; then
    echo -e "${green}[+]${nc} Instalando ${program}..."
    sleep 0.05
    command="sudo ${package} install ${program} -y"
    echo -e "${grey}$ ${command}${nc}"
    sleep 0.05
    if "$command" 2>>"${error_logs}" ; then
        echo -e "${green}[+]${nc} ${program} ha sido instalado"
    else
        echo -e "${red}[!]${nc} ${program} no ha podido ser instalado"
        salir
    fi
  else
    echo -e "${yellow}[!]${nc} Saltando instalación de ${program}..."
  fi
  echo ""
}

function pre_requisites(){
  programs=(git wget curl)
  for program in "${programs[@]}"; do
    install "${program}"
  done
}

function plugins_zsh(){
    echo -e "${green}[+]${nc} Vamos a crear la carpeta para los plugins de la zsh"
    actual_path=$(pwd)
    sudo mkdir -p /usr/share/zsh-plugins/
    cd /usr/share/zsh-plugins/ || return
    sleep 0.04
    echo -e "${green}[s]${nc} Voy a necesitar permisos de sudo para poder descargar los plugins de la zsh en /usr/share/zsh-pugins/"
    {
    sudo wget -b -t 5 "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/pugins/sudo/sudo.plugin.zsh"
    sudo wget -b -t 5 "https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh"
    sudo wget -b -t 5 "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/jsontools/jsontools.plugin.zsh"
    sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
    } 2>> "${error_logs}"
    rm -rf wget-log*
    cd - || cd "$actual_path" || return
}

function zsh(){
  echo "${green}[s]${nc} Instalando zsh..."
  command="sudo ${package} install zsh -y"
  echo -e "${grey}$ ${command}${nc}"
  sleep 0.05
  eval "$command" 2>>"${error_logs}"
}

function powerlevel10k(){
    echo "${green}[+]${nc} Instalando powerlevel10k..."
    sleep 0.05
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k 2>>"${error_logs}"
    echo "Ahora instala la powerlevel10k con el comando p10k configure"
}

function mpv_youtube_dl(){
    echo -e "${green}[s]${nc} Instalando mpv y youtube-dl..."
    command="sudo ${package} install mpv youtube-dl -y"
    echo -e "${grey}$ ${command}${nc}"
    sleep 0.05
    eval "$command" 2>>"${error_logs}"
}

function backup(){
  echo -e "Vamos a hacer un backup de tu configuración actual"
  mkdir -p ~/.config/backup-dotfiles
  for dotfile in "${dotfiles[@]}"; do
    if [ -f "$HOME/$dotfile" ]; then
      if cp "$HOME/$dotfile" "$HOME/.config/backup-dotfiles/$dotfile.bak" 2>>"${error_logs}"; then
        echo -e "${green}[+]${nc} ${dotfile} ha sido copiado a ~/.config/backup/${dotfile}.bak"
      else
        echo -e "${red}[!]${nc} ${dotfile} no ha podido ser copiado a ~/.config/backup/${dotfile}.bak"
      fi
      echo ""
    fi
    if [ "$dotfile" = "rc.lua" ] ; then
        if [ -d ~/.config/awesome ]; then
          if cp -r ~/.config/awesome ~/.config/backup-dotfiles/awesome.bak 2>>"${error_logs}"; then
            echo -e "${green}[+]${nc} ${dotfile} ha sido copiado a ~/.config/backup/awesome.bak"
          else
            echo -e "${red}[!]${nc} ${dotfile} no ha podido ser copiado a ~/.config/backup/awesome.bak"
          fi
          echo ""
        else
          echo -e "${yellow}[!]${nc} No tienes la carpeta ~/.config/awesome"
        fi
    fi
  done
}

function dotfiles-installation(){
  backup
  echo -e "Instalando los dotfiles"
  sleep 0.05
  for dotfile in "${dotfiles[@]}"; do
    if [ -f "$HOME/$dotfile" ]; then
      if rm "$HOME/$dotfile" 2>>"${error_logs}"; then
        echo -e "${green}[-] ${nc}${dotfile} ha sido borrado"
      else
        echo -e "${red}[!] ${nc}${dotfile} no ha podido ser borrado"
      fi
    fi
    if [ "$dotfile" = "rc.lua" ]; then
      mkdir -p ~/.config/awesome
      if rm ~/.config/awesome/rc.lua 2>>"${error_logs}"; then
        echo -e "${green}[-] ${nc}${dotfile} ha sido borrado"
      else
        echo -e "${red}[!] ${nc}${dotfile} no ha podido ser borrado"
      fi
      dotfile_dir="/.config/awesome/rc.lua"
    else
      dotfile_dir="$dotfile"
    fi
    ln -s "${HOME}/dotfiles/$dotfile" "${HOME}/$dotfile_dir"

    if [ $? == 0 ] 2>>"${error_logs}"; then
      echo -e "${green}[+] ${nc}${dotfile} ha sido instalado"
    else
      echo -e "${red}[!] ${nc}${dotfile} no ha podido ser instalado"
    fi
    echo ""
    sleep 0.05
  done
  rm -rf "${HOME}"/dotfiles/bashrc/aliases.sh
  rm -rf "${HOME}"/dotfiles/bashrc/utils.sh
  ln -s -n "${HOME}/dotfiles/zshrc/aliases.sh" "${HOME}/dotfiles/bashrc/aliases.sh"
  ln -s -n "${HOME}/dotfiles/zshrc/utils.sh" "${HOME}/dotfiles/bashrc/utils.sh"
  sleep 0.05
}

function tmux(){
    command="sudo ${package} install tmux -y"
    echo -e "${green}[+]${nc}Instalando tmux"
    echo -e "${grey}$ ${command}${nc}"
    sleep 0.05
    eval "$command" 2>>"${error_logs}"
}

function lsd_i386(){
    command="wget https://github.com/Peltoche/lsd/releases/download/0.17.0/lsd_0.17.0_i386.deb"
    echo -e "${green}[+]${nc}Instalando lsd"
    eval "$command" 2>>"${error_logs}"
    command="sudo dpkg -i lsd_0.17.0_i386.deb"
    echo -e "${grey}$ ${command}${nc}"
    eval "$command" 2>>"${error_logs}"
    rm lsd_0.17.0_i386.deb
    sleep 0.05
}

function lsd_amd64(){
    command="wget https://github.com/Peltoche/lsd/releases/download/0.23.0/lsd_0.23.0_amd64.deb"
    echo -e "${green}[+]${nc}Instalando lsd"
    eval "$command" 2>>"${error_logs}"
    command="sudo dpkg -i lsd_0.23.0_amd64.deb"
    echo -e "${grey}$ ${command}${nc}"
    eval "$command" 2>>"${error_logs}"
    rm lsd_0.23.0_amd64.deb
    sleep 0.05
  }

function salir(){
    echo -e "${red}[!]${nc} Saliendo..."
    echo -e "${red}[L]${nc} Si has tenido algún problema, puedes ver el log de errores en ${error_logs}"
    sleep 0.02
    tput cnorm
    exit 0
}

function main(){
  PS3="[?]: "
  echo -e "${green}[*]${nc} Elige un número para instalar lo que quieras:\n"
  if [[ ${package} = "none" ]]; then
    programs=(backup powerlevel10k plugins_zsh dotfiles-installation lsd_i386 lsd_amd64 salir)
  else
    programs=(zsh backup powerlevel10k mpv_youtube_dl dotfiles-installation tmux plugins_zsh lsd_i386 lsd_amd64 salir)
  fi
  while [[ 1 -eq 1 ]]; do
    select program in "${programs[@]}"; do
      echo -e "\n${green}[*]${nc} Has seleccionado ${program} \n"
      sleep 0.05
      "$program"
      break
    done
  done
    exit 0
}

function identify_package_manager(){
  if [ "${package}" == "none" ]; then
    if [ "$(command -v apt)" ]; then
        package="apt"
    elif [ "$(command -v pacman)" ]; then
        package="pacman"
    elif [ "$(command -v dnf)" ]; then
        package="dnf"
    elif [ "$(command -v yum)" ]; then
        package="yum"
    else
        package="none"
    fi
    echo -e "${green}[+]${nc} Vamos a usar el gestor ${package}"
  else
    echo -e "${green}[+]${nc} Gestior de paquetes forzado a ${package}"
  fi
}

tput civis

while getopts ":qp:" option; do
  case "${option}" in
    q) quiet=1;;
    p) package="$OPTARG";;
    *) echo -e "${red}[!]${nc} Opción inválida: -$OPTARG" >&2;;
  esac
done

identify_package_manager

if [ "${quiet}" == 0 ]; then
  bruce_banner
  pre_requisites
fi

main
