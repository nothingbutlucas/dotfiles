#!/usr/bin/bash

grey=$(tput setaf 8)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
red=$(tput setaf 1)
nc=$(tput sgr0)


error_logs=$(pwd)/error_logs.log
dotfiles=(.bashrc .zshrc .tmux.conf .gitconfig .gitignore .Xdefaults)

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

function plugins_zsh(){
    echo -e "${green}[+]${nc} Vamos a crear la carpeta para los plugins de la zsh"
    sudo mkdir -p /usr/share/zsh-plugins/
    cd /usr/share/zsh-plugins/
    sleep 0.04
    echo -e "${green}[s]${nc} Voy a necesitar permisos de sudo para poder descargar los plugins de la zsh en /usr/share/zsh-plugins/"
    sudo wget --nocache -b -t 5 "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh" 2>>${error_logs}
    sudo wget --nocache -b -t 5 "https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh" 2>>${error_logs}
    sudo wget --nocache -b -t 5 "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/jsontools/jsontools.plugin.zsh" 2>>${error_logs}
    sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git 2>>${error_logs}
    cd -
}

function zsh(){
    echo "${green}[s]${nc} Instalando zsh..."
    command="sudo $package install zsh -y"
    echo -e "${grey}$ ${command}${nc}"
    sleep 0.05
    eval $command 2>>${error_logs}
}

function powerlevel10k(){
    echo "${green}[+]${nc} Instalando powerlevel10k..."
    sleep 0.05
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k 2>>${error_logs}
    echo "Ahora instala la powerlevel10k con el comando p10k configure"
}

function mpv_youtube_dl(){
    echo -e "${green}[s]${nc} Instalando mpv y youtube-dl..."
    command="sudo $package install mpv youtube-dl -y"
    echo -e "${grey}$ ${command}${nc}"
    sleep 0.05
    eval $command 2>>${error_logs}
}

function backup(){
    echo -e "Vamos a hacer un backup de tu configuración actual"
    mkdir -p ~/.config/backup
    for dotfile in ${dotfiles[@]}; do
        if [ -f ~/$dotfile ]; then
            cp ~/$dotfile ~/.config/backup/$dotfile.bak 2>>${error_logs}
            if [ $? -eq "0" ] ; then
                echo -e "${green}[+]${nc} ${dotfile} ha sido copiado a ~/.config/backup/${dotfile}.bak"
            else
                echo -e "${red}[!]${nc} ${dotfile} no ha podido ser copiado a ~/.config/backup/${dotfile}.bak"
            fi
            echo ""
        fi
    done
}

function dotfiles(){
    backup
    echo -e "Instalando los dotfiles"
    sleep 0.05
    for dotfile in ${dotfiles[@]}; do
        if [ -f ~/$dotfile ]; then
            rm ~/$dotfile 2>>${error_logs}
            if [ $? -eq "0" ]; then
                echo -e "${green}[-] ${nc}${dotfile} ha sido borrado"
            else
                echo -e "${red}[!] ${nc}${dotfile} no ha podido ser borrado"
            fi
        fi
        ln -s $HOME/dotfiles/$dotfile ~/$dotfile 2>>${error_logs}
        if [ $? -eq "0" ]; then
            echo -e "${green}[+] ${nc}${dotfile} ha sido instalado"
        else
            echo -e "${red}[!] ${nc}${dotfile} no ha podido ser instalado"
        fi
        echo ""
        sleep 0.05
    done
    rm -rf $HOME/dotfiles/bashrc/aliases.sh
    rm -rf $HOME/dotfiles/bashrc/utils.sh
    ln -s -n ${HOME}/dotfiles/zshrc/aliases.sh ${HOME}/dotfiles/bashrc/aliases.sh
    ln -s -n ${HOME}/dotfiles/zshrc/utils.sh ${HOME}/dotfiles/bashrc/utils.sh
    sleep 0.05
}

function tmux(){
    command="sudo $package install tmux -y"
    echo -e "${green}[+]${nc}Instalando tmux"
    echo -e "${grey}$ ${command}${nc}"
    sleep 0.05
    eval $command 2>>${error_logs}
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
    if [[ $package = "none" ]]; then
        programs='backup powerlevel10k plugins_zsh dotfiles salir'
    else
        programs='zsh backup powerlevel10k mpv_youtube_dl dotfiles tmux plugins_zsh salir'
    fi
    while [[ 1 -eq 1 ]]; do
        select program in $programs; do
            echo -e "\n${green}[*]${nc} Has seleccionado $program \n"
            sleep 0.05
            $program
            break
        done
    done
        exit 0
}

function identify_package_manager(){
    if [ $(command -v apt) ]; then
        package="apt"
    elif [ $(command -v pacman) ]; then
        package="pacman"
    elif [ $(command -v dnf) ]; then
        package="dnf"
    elif [ $(command -v yum) ]; then
        package="yum"
    else
        package="none"
    fi
    echo -e "${green}[+]${nc} Vamos a usar el gestor $package"
}
tput civis

bruce_banner

identify_package_manager

main
