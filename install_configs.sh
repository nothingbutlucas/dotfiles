#!/usr/bin/bash

# Note: The -e flag will cause the script to exit if any command fails.

# Description: Install configuration dotfiles
# Author: @nothingbutlucas
# Version: 1.0.0
# License: GNU General Public License v3.0

# Colours and uses

red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
purple="\e[35m"
cyan="\e[36m"
cmd="\e[37m"
nc="\e[0m"

wrong="${red}"
good="${green}"
warn="${yellow}"
info="${blue}"
ask="${purple}"
doing="${cyan}"
cmd="${grey}"

sign_wrong="${wrong}[-]${nc}"
sign_good="${good}[+]${nc}"
sign_warn="${warn}[!]${nc}"
sign_info="${info}[i]${nc}"
sign_ask="${ask}[?]${nc}"
sign_doing="${doing}[~]${nc}"
sign_cmd="${cmd}[>]${nc}"
sign_debug="${warn}[d]${nc}"

error_logs=$(pwd)/error_logs.log
dotfiles=(.bashrc .zshrc .tmux.conf .gitconfig .gitignore .Xdefaults rc.lua .picom .ideavimrc kitty)

quiet=0
package="none"

trap ctrl_c INT

function ctrl_c() {
	salir
}

function bruce_banner() {
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

function is_installed() {
	program=$1
	echo -e "${sign_good} Comprobando si tienes instalado ${program}..."
	sleep 0.05
	echo -e "${sign_cmd}$ command -v ${program} ${nc}"
	sleep 0.05
	if command -v "${program}" 1>/dev/null 2>>"${error_logs}"; then
		echo -e "${sign_info} ${program} está instalado"
		return 0
	else
		echo -e "${sign_wrong} ${program} no está instalado"
		return 1
	fi
}

function install() {
	program=$1
	if ! is_installed "${program}"; then
		echo -e "${sign_good} Instalando ${program}..."
		sleep 0.05
		command="sudo ${package} install ${program} -y"
		echo -e "${sign_cmd}$ ${command}${nc}"
		sleep 0.05
		if "$command" 2>>"${error_logs}"; then
			echo -e "${sign_good} ${program} ha sido instalado"
		else
			echo -e "${sign_wrong} ${program} no ha podido ser instalado"
			salir
		fi
	else
		echo -e "${sign_warn} Saltando instalación de ${program}..."
	fi
	echo ""
}

function pre_requisites() {
	programs=(git wget curl unzip)
	for program in "${programs[@]}"; do
		install "${program}"
	done
}

function batcat() {
	install "bat"
}

function fonts() {
	# Comprobar si las fuentes existen
	echo -e "${sign_good} Comprobando si tienes instaladas las fuentes HackNerdFont..."
	fonts_files=$(ls /usr/local/share/fonts/ | grep Hack)
	if [ -z "${fonts_files}" ]; then
		echo -e "${sign_wrong} No tienes instaladas las fuentes HackNerdFont"
		echo -e "${sign_good} Vamos a instalar las fuentes HackNerdFont"
		echo -e "${sign_good} Vamos a descargar la fuente HackNerdFont de https://www.nerdfonts.com/"
		wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip
		# Comprobamos que el archivo Hack.zip exista
		if [ ! -f Hack.zip ]; then
			echo -e "${sign_wrong} No se ha podido descargar la fuente HackNerdFont"
		else
			echo -e "${sign_doing} Voy a necesitar permisos de sudo para poder descomprimir las fuentes en /usr/local/share/fonts"
			unzip -q Hack.zip -d /usr/local/share/fonts/
		fi
	else
		echo -e "${sign_info} Tienes instaladas las fuentes HackNerdFont"
		echo -e "${sign_warn} Saltando instalación de ${program}..."
	fi

}

function plugins_zsh() {
	echo -e "${sign_good} Vamos a crear la carpeta para los plugins de la zsh"
	actual_path=$(pwd)
	zsh_plugins_path="/usr/share/zsh-plugins/"
	sudo mkdir -p "${zsh_plugins_path}"
	cd ${zsh_plugins_path} || return
	sleep 0.04
	echo -e "${sign_doing} Voy a necesitar permisos de sudo para poder descargar los plugins de la zsh en /usr/share/zsh-pugins/"
	# Comprobar si los plugins ya existen
	echo -e "${sign_good} Comprobando si tienes instalados los plugins de la zsh..."
	zsh_plugins=$(ls "${zsh_plugins_path}")
	sudo_plugin_zsh=0
	zsh_auto_suggestions=0
	jsontools_plugin_zsh=0
	zsh_syntax_highlighting=0
	for x in $zsh_plugins; do
		if [ "$x" == "sudo.plugin.zsh" ]; then
			sudo_plugin_zsh=1
		elif [ "$x" == "zsh-autosuggestions.zsh" ]; then
			zsh_auto_suggestions=1
		elif [ "$x" == "jsontools.plugin.zsh" ]; then
			jsontools_plugin_zsh=1
		elif [ "$x" == "zsh-syntax-highlighting" ]; then
			zsh_syntax_highlighting=1
		fi
	done
	if [ $sudo_plugin_zsh -eq 0 ]; then
		echo -e "${sign_doing} Descargando el plugin sudo.plugin.zsh..."
		sudo wget -q "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh" 2>>"${error_logs}"
	else
		echo -e "${sign_info} Tienes instalado el plugin sudo.plugin.zsh"
	fi
	if [ $zsh_auto_suggestions -eq 0 ]; then
		echo -e "${sign_doing} Descargando el plugin zsh-autosuggestions.zsh..."
		sudo wget -q "https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh" 2>>"${error_logs}"
	else
		echo -e "${sign_info} Tienes instalado el plugin zsh-autosuggestions.zsh"
	fi
	if [ $jsontools_plugin_zsh -eq 0 ]; then
		echo -e "${sign_doing} Descargando el plugin jsontools.plugin.zsh..."
		sudo wget -q "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/jsontools/jsontools.plugin.zsh" 2>>"${error_logs}"
	else
		echo -e "${sign_info} Tienes instalado el plugin jsontools.plugin.zsh"
	fi
	if [ "$zsh_syntax_highlighting" -eq 0 ]; then
		echo -e "${sign_doing} Descargando el plugin zsh-syntax-highlighting..."
		sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git 2>>"${error_logs}"
		echo -e "${sign_doing} Instalando el plugin zsh-syntax-highlighting..."
	fi
	cd "$actual_path"
	echo ""
}

function zsh() {
	echo "${sign_doing} Instalando zsh..."
	command="sudo ${package} install zsh -y"
	echo -e "${sign_cmd}$ ${command}${nc}"
	sleep 0.05
	eval "$command" 2>>"${error_logs}"
}

function powerlevel10k() {
	echo "${sign_good} Instalando powerlevel10k..."
	sleep 0.05
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k 2>>"${error_logs}"
	echo "Ahora instala la powerlevel10k con el comando p10k configure"
}

function mpv_youtube_dl() {
	echo -e "${sign_doing} Instalando mpv y youtube-dl..."
	command="sudo ${package} install mpv youtube-dl -y"
	echo -e "${sign_cmd} ${command}${nc}"
	sleep 0.05
	eval "$command" 2>>"${error_logs}"
}

function backup() {
	echo -e "${sign_doing} Vamos a hacer un backup de tu configuración actual"
	mkdir -p ~/.config/backup-dotfiles
	for dotfile in "${dotfiles[@]}"; do
		if [ -f "$HOME/$dotfile" ]; then
			if cp "$HOME/$dotfile" "$HOME/.config/backup-dotfiles/$dotfile.bak" 2>>"${error_logs}"; then
				echo -e "${sign_good} ${dotfile} ha sido copiado a ~/.config/backup/${dotfile}.bak"
			else
				echo -e "${sign_wrong} ${dotfile} no ha podido ser copiado a ~/.config/backup/${dotfile}.bak"
			fi
			echo ""
		fi
		if [ "$dotfile" = "rc.lua" ]; then
			if [ -d ~/.config/awesome ]; then
				if cp -r ~/.config/awesome ~/.config/backup-dotfiles/awesome.bak 2>>"${error_logs}"; then
					echo -e "${sign_good} ${dotfile} ha sido copiado a ~/.config/backup/awesome.bak"
				else
					echo -e "${sign_wrong} ${dotfile} no ha podido ser copiado a ~/.config/backup/awesome.bak"
				fi
				echo ""
			else
				echo -e "${sign_warn} No tienes la carpeta ~/.config/awesome"
			fi
		fi
	done
}

function dotfiles-installation() {
	backup
	echo -e "${sign_doing} Instalando los dotfiles"
	sleep 0.05
	for dotfile in "${dotfiles[@]}"; do

		if [ -f "$HOME/$dotfile" ]; then
			if rm "$HOME/$dotfile" 2>>"${error_logs}"; then
				echo -e "${sign_good} ${dotfile} ha sido borrado"
			else
				echo -e "${sign_wrong} ${dotfile} no ha podido ser borrado"
			fi
		fi

		if [ "$dotfile" == "rc.lua" ]; then
			mkdir -p ~/.config/awesome
			if rm ~/.config/awesome/rc.lua 2>>"${error_logs}"; then
				echo -e "${sign_good} ${dotfile} ha sido borrado"
			else
				echo -e "${sign_wrong} ${dotfile} no ha podido ser borrado"
			fi
			dotfile_dir="/.config/awesome/rc.lua"
		else
			dotfile_dir="$dotfile"
		fi

		if [ "$dotfile" == "kitty" ]; then
			mv ~/.config/kitty ~/.config/kitty_bak
		fi

		ln -s "${HOME}/dotfiles/$dotfile" "${HOME}/$dotfile_dir"

		if [ $? == 0 ] 2>>"${error_logs}"; then
			echo -e "${sign_good} ${dotfile} ha sido instalado"
		else
			echo -e "${sign_wrong} ${dotfile} no ha podido ser instalado"
		fi

		echo ""
		sleep 0.05

	done

	rm -rf "${HOME}"/dotfiles/bashrc/aliases.sh
	rm -rf "${HOME}"/dotfiles/bashrc/utils.sh
	ln -s -n "${HOME}/dotfiles/zshrc/aliases.sh" "${HOME}/dotfiles/bashrc/aliases.sh"
	ln -s -n "${HOME}/dotfiles/zshrc/utils.sh" "${HOME}/dotfiles/bashrc/utils.sh"
	ln -s -n "${HOME}/dotfiles/kitty" "${HOME}/.config/kitty"
	sleep 0.05
}

function tmux() {
	command="sudo ${package} install tmux -y"
	echo -e "${sign_good} Instalando tmux"
	echo -e "${sign_cmd} ${command}${nc}"
	sleep 0.05
	eval "$command" 2>>"${error_logs}"
}

function lsd_i386() {
	command="wget https://github.com/Peltoche/lsd/releases/download/0.17.0/lsd_0.17.0_i386.deb"
	echo -e "${sign_good} Instalando lsd"
	eval "$command" 2>>"${error_logs}"
	command="sudo dpkg -i lsd_0.17.0_i386.deb"
	echo -e "${sign_cmd} ${command}${nc}"
	eval "$command" 2>>"${error_logs}"
	rm lsd_0.17.0_i386.deb
	sleep 0.05
}

function lsd_amd64() {
	command="wget https://github.com/Peltoche/lsd/releases/download/0.23.0/lsd_0.23.0_amd64.deb"
	echo -e "${sign_good} Instalando lsd"
	eval "$command" 2>>"${error_logs}"
	command="sudo dpkg -i lsd_0.23.0_amd64.deb"
	echo -e "${sign_cmd} ${command}${nc}"
	eval "$command" 2>>"${error_logs}"
	rm lsd_0.23.0_amd64.deb
	sleep 0.05
}

function salir() {
	echo -e "${sign_wrong} Saliendo..."
	echo -e "${sign_warn} Si tuviste algún problema, podes ver el log de errores en ${error_logs}"
	sleep 0.02
	tput cnorm
	exit 0
}

function main() {
	PS3="[?]: "
	echo -e "${sign_ask} Elige un número para instalar lo que quieras:\n"
	if [[ ${package} = "none" ]]; then
		programs=(backup powerlevel10k plugins_zsh dotfiles-installation lsd_i386 lsd_amd64 fonts salir)
	else
		programs=(zsh backup powerlevel10k mpv_youtube_dl dotfiles-installation tmux plugins_zsh lsd_i386 lsd_amd64 fonts batcat salir)
	fi
	while [[ 1 -eq 1 ]]; do
		select program in "${programs[@]}"; do
			echo -e "\n${sign_ask} Has seleccionado ${program} \n"
			sleep 0.05
			"$program"
			break
		done
	done
	exit 0
}

function identify_package_manager() {
	if [ "${package}" == "none" ]; then
		if [ "$(command -v apt)" ]; then
			package="apt"
		elif [ "$(command -v pacman)" ]; then
			package="pacman"
		elif [ "$(command -v dnf)" ]; then
			package="dnf"
		elif [ "$(command -v yum)" ]; then
			package="yum"
		elif [ "$(command -v pkg)" ]; then
			package="pkg"
		else
			package="none"
		fi
		echo -e "${sign_good} Vamos a usar el gestor ${package}"
	else
		echo -e "${sign_good} Gestior de paquetes forzado a ${package}"
	fi
}

tput civis

while getopts ":qp:" option; do
	case "${option}" in
	q) quiet=1 ;;
	p) package="$OPTARG" ;;
	*) echo -e "${sign_wrong} Opción inválida: -$OPTARG" >&2 ;;
	esac
done

identify_package_manager

if [ "${quiet}" == 0 ]; then
	bruce_banner
	pre_requisites
fi

main
