#!/usr/bin/env sh

grey=$(tput setaf 8)
white=$(tput setaf 7)

system=$( cat /etc/os-release | grep -i "ID=" | cut -d "=" -f 2 | head -n 1 )

if [[ $system = "fedora" || $system = "rhel" ]]; then
    package="dnf"
elif [[ $system = "debian" || $system = "ubuntu" ]]; then
    package="apt"
else
    echo -e "No se ha podido reconocer el sistema :("
    exit 1
fi

function plugins_zsh(){
    echo -e "Vamos a crear la carpeta para los plugins de la zsh"
    sudo mkdir -p /usr/share/zsh-plugins/
    echo -e "Me descargo los plugins de la zsh"
    cd /usr/share/zsh-plugins/
    echo -e "Voy a necesitar permisos de sudo para poder descargar los plugins de la zsh en /usr/share/zsh-plugins/"
    sudo wget -b -t 5 "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh"
    sudo wget -b -t 5 "https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh"
    sudo wget -b -t 5 "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/jsontools/jsontools.plugin.zsh"
    sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
    cd -
}

function zsh(){
    echo "Instalando zsh..."
    sleep 0.5
    command="sudo $package install zsh -y"
    eval $command
}

function powerlevel10k(){
    echo "Instalando powerlevel10k..."
    sleep 0.5
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo "Ahora instala la powerlevel10k con el comando p10k configure"
}

function mpv_youtube_dl(){
    echo -e "Instalando mpv"
    sleep 0.5
    sudo $package install mpv -y
    echo -e "Instalando youtube-dl"
    sleep 0.5
    sudo $package install youtube-dl -y
}

function backup(){
    echo -e "Vamos a hacer un backup de tu configuración actual"
    mkdir -p ~/.config/backup
    cp ~/.zshrc ~/.config/backup/zshrc.bak > /dev/null 2>&1
    echo -e "${grey}$ Backup realizado en ~/.config/backup/zshrc.bak${white}"
    cp ~/.gitconfig ~/.config/backup/gitconfig.bak > /dev/null 2>&1
    echo -e "${grey}$ Backup realizado en ~/.config/backup/gitconfig.bak${white}"
    cp ~/.bashrc ~/.config/backup/bashrc.bak > /dev/null 2>&1
    echo -e "${grey}$ Backup realizado en ~/.config/backup/bashrc.bak${white}"
    cp ~/.tmux.conf ~/.config/backup/tmux.conf.bak > /dev/null 2>&1
    echo -e "${grey}$ Backup realizado en ~/.config/backup/tmux.conf.bak${white}"
}

function dotfiles(){
    cd $HOME
    cd dotfiles
    backup
    echo -e "Instalando los dotfiles"
    sleep 0.5
    ln -s -n $HOME/dotfiles/.gitconfig $HOME/.gitconfig
    echo ".gitconfig instalado"
    ln -s -n $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
    echo ".tmux.conf instalado"
    ln -s -n $HOME/dotfiles/.zshrc $HOME/.zshrc
    echo ".zshrc instalado"
    ln -s -n $HOME/dotfiles/.bashrc $HOME/.bashrc
    ln -s -n "${HOME}/dotfiles/zshrc/alias.sh" "${HOME}/dotfiles/bashrc/alias.sh"
    ln -s -n "${HOME}/dotfiles/zshrc/utils.sh" "${HOME}/dotfiles/bashrc/utils.sh"
    echo ".bashrc instalado"
}

function tmux(){
    command="sudo $package install tmux -y"
    echo -e "Instalando tmux"
    sleep 0.5
    echo -e "${grey}$ ${command}${white}"
    eval $command
}

function salir(){
    echo -e "Saliendo..."
    sleep 0.5
    exit 0
}

function main(){
    while [[ 1 -eq 1 ]]; do
        PS3="Elegi el programa que quieras instalar: "
        select program in "zsh" "powerlevel10k" "mpv_youtube-dl" "dotfiles" "tmux" "plugins_zsh" "salir"; do
            echo -e "Has seleccionado $program \n"
            sleep 0.5
            $program
            break
        done
    done
        exit 0
}

main
