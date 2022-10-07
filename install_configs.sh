#!/usr/bin/env bash

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
    echo -e "[+] Vamos a crear la carpeta para los plugins de la zsh"
    sudo mkdir -p /usr/share/zsh-plugins/
    cd /usr/share/zsh-plugins/
    sleep 0.04
    echo -e "[s] Voy a necesitar permisos de sudo para poder descargar los plugins de la zsh en /usr/share/zsh-plugins/"
    sudo wget --nocache -b -t 5 "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh"
    sudo wget --nocache -b -t 5 "https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh"
    sudo wget --nocache -b -t 5 "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/jsontools/jsontools.plugin.zsh"
    sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
    cd -
}

function zsh(){
    echo "[s] Instalando zsh..."
    command="sudo $package install zsh -y"
    echo -e "${grey}$ ${command}${white}"
    sleep 0.05
    eval $command
}

function powerlevel10k(){
    echo "[+] Instalando powerlevel10k..."
    sleep 0.05
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo "Ahora instala la powerlevel10k con el comando p10k configure"
}

function mpv_youtube_dl(){
    echo -e "[s] Instalando mpv y youtube-dl..."
    command="sudo $package install mpv youtube-dl -y"
    echo -e "${grey}$ ${command}${white}"
    sleep 0.05
    eval $command
}

function backup(){
    echo -e "Vamos a hacer un backup de tu configuración actual"
    mkdir -p ~/.config/backup
    cp ~/.zshrc ~/.config/backup/zshrc.bak > /dev/null 2>&1
    echo -e "Backup realizado en ~/.config/backup/zshrc.bak${white}"
    cp ~/.gitconfig ~/.config/backup/gitconfig.bak > /dev/null 2>&1
    echo -e "Backup realizado en ~/.config/backup/gitconfig.bak${white}"
    cp ~/.bashrc ~/.config/backup/bashrc.bak > /dev/null 2>&1
    echo -e "Backup realizado en ~/.config/backup/bashrc.bak${white}"
    cp ~/.tmux.conf ~/.config/backup/tmux.conf.bak > /dev/null 2>&1
    echo -e "Backup realizado en ~/.config/backup/tmux.conf.bak${white}"
}

function dotfiles(){
    cd $HOME
    cd dotfiles
    backup
    echo -e "Instalando los dotfiles"
    sleep 0.05
    rm -rf "$HOME/.gitconfig"
    ln -s -n $HOME/dotfiles/.gitconfig $HOME/.gitconfig
    echo ".gitconfig instalado"
    sleep 0.05
    rm -rf "$HOME/.tmux.conf"
    ln -s -n $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
    echo ".tmux.conf instalado"
    sleep 0.05
    rm -rf "$HOME/.zshrc"
    ln -s -n $HOME/dotfiles/.zshrc $HOME/.zshrc
    echo ".zshrc instalado"
    sleep 0.05
    rm -rf "$HOME/.bashrc"
    ln -s -n $HOME/dotfiles/.bashrc $HOME/.bashrc
    rm -rf "$HOME/bashrc/alias.sh"
    rm -rf "$HOME/bashrc/utils.sh"
    ln -s -n ${HOME}/dotfiles/zshrc/alias.sh" "${HOME}/dotfiles/bashrc/alias.sh
    ln -s -n ${HOME}/dotfiles/zshrc/utils.sh" "${HOME}/dotfiles/bashrc/utils.sh
    echo ".bashrc instalado"
    sleep 0.05
}

function tmux(){
    command="sudo $package install tmux -y"
    echo -e "[+]Instalando tmux"
    echo -e "${grey}$ ${command}${white}"
    sleep 0.05
    eval $command
}

function salir(){
    echo -e "[x] Saliendo..."
    sleep 0.02
    exit 0
}

function main(){
    PS3="[?]: "
    echo -e "[*] Elige un número para instalar lo que quieras:\n"
    if [[ $package = "none" ]]; then
        programs='powerlevel10k plugins_zsh dotfiles salir'
    else
        programs='zsh powerlevel10k mpv_youtube_dl dotfiles tmux plugins_zsh salir'
    fi
    while [[ 1 -eq 1 ]]; do
        select program in $programs; do
            echo -e "\n[*] Has seleccionado $program \n"
            sleep 0.05
            $program
            break
        done
    done
        exit 0
}

grey=$(tput setaf 8)
white=$(tput setaf 7)

distro=$(lsb_release -is)

bruce_banner

if [[ ${distro,} = "fedora" || ${distro,} = "rhel" ]]; then
    package="dnf"
elif [[ ${distro,} = "debian" || ${distro,} = "ubuntu" ]]; then
    package="apt"
else
    package="none"
    echo "La distribución $system aún tiene soporte al 100%"
    exit 1
fi

main
