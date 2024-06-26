yt_lucky() {
	mpv --no-video $(ddgr -n 1 -x -w youtube.com $1 | grep 'https://www.youtube.com/watch?v=.*')
}

permissions_linux() {

	echo -e "| Read | Write | Execute |"
	echo -e "|------|-------|---------|"
	echo -e "| +4   | +2    | +1      |"
	echo -e "                          "
	echo -e "--- --- ---               "
	echo -e " U   G   O                "
	echo -e "                          "
	echo -e "| User | Group | Others  |"
	echo -e "|------|-------|---------|"
	echo -e "| 1-7  | 1-7   | 1-7     |"

}

function lss() {
	if [[ $# = 1 ]]; then
		lsd $1 --sort time
	else
		e_arrow "Adonde tiramos el lss?: "
		read folder
		lsd $folder --sort time
	fi
}

function mcd() {
	if [[ $# = 1 ]]; then
		mkdir -p $1
		cd $1
	else
		e_arrow "Nombre de nueva carpeta: "
		read folder
		mkdir -p $folder
		cd $folder
	fi
}

function pwdd() {
	pwd
	pwd | xclip -sel clip >/dev/null 2>&1
	e_success " [ + ] Ruta copiada al clipboard [ + ]"
}

function create_note() {
	if [[ $# = 2 ]]; then
		FILENAME=$(date +%d-%m)_$2.md
		if [[ -d $1 ]]; then
			cd $1
		else
			mkdir -p $1
			cd $1
		fi
		touch $FILENAME
		nvim $FILENAME
	else
		e_arrow "Donde queres crear la nota?"
		read the_note_dir
		e_arrow "Cómo se va a llamar la nota?"
		read the_note
		FILENAME=$(date +%d-%m)_$the_note.md
		if [[ -d $the_note_dir ]]; then
			cd $the_note_dir
		else
			mkdir -p $the_note_dir
			cd $the_note_dir
		fi
		touch $FILENAME
		nvim $FILENAME
	fi
}

function man() {
	env \
		LESS_TERMCAP_mb=$'\e[01;31m' \
		LESS_TERMCAP_md=$'\e[01;31m' \
		LESS_TERMCAP_me=$'\e[0m' \
		LESS_TERMCAP_se=$'\e[0m' \
		LESS_TERMCAP_so=$'\e[01;44;33m' \
		LESS_TERMCAP_ue=$'\e[0m' \
		LESS_TERMCAP_us=$'\e[01;32m' \
		man "$@"
}

function rmk() {
	scrub -p dod $1
	shred -zun 10 -v $1
}

function porcentaje() {
	if [[ $# = 2 ]]; then
		porcentaje=$(($1 * 100 / $2))
		e_success "${1} es el $porcentaje % de ${2}"
	else
		e_arrow "Decime el primer numero que sera un porcentaje del segundo"
		read numero_1
		e_arrow "Pasame el segundo numero"
		read numero_2

		porcentaje=$(($numero_1 * 100 / $numero_2))

		e_success "$numero_1 es el $porcentaje % de $numero_2"

	fi
}

function timezsh() {
	shell=${1-$SHELL}
	for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

function alerta() {
	e_arrow "Hora de alerta"
	read alarma_hora
	e_arrow "Minuto de alerta"
	read minuto_de_alarma
	e_arrow "Titulo de alarma"
	read titulo_de_alarma
	e_arrow "Descripcion de alarma"
	read descripcion_de_alarma
	cron_task="${minuto_de_alarma} ${alarma_hora} * * * notify-send '${titulo_de_alarma}' '${descripcion_de_alarma}' -u critical -i emblem-important"
	echo $cron_task | xclip -sel clip >/dev/null 2>&1
	crontab -e
}

function mv_pritty() {
	string=$(echo $1 | sed 's/ /_/g')
	mv $1 ${string:l}
	e_success "Archivo renombrado a ${string:l}"
}

function cp_and_notify() {
	cp -rp $1 $2
	curl -H "Title: PC" -H "tags: computer" -H "Priority: high" -d "Se copio correctamente $1 a $2" ntfy.sh/$TOPICO_CP
}

function search_in_all_folders() {
	if [ -z "$1" ]; then
		e_arrow "Que quieres buscar?\n"
		read search
	else
		search=$1
	fi
	grep -r -l "$search" .
}

function kill-ps() {
	if [ -z "$1" ]; then
		e_arrow "Que proceso quieres matar?\n"
		read -r process
	else
		process=$1
	fi
	sudo kill -9 $(ps aux | grep $process | awk '{print $2}')
	e_arrow "\$(ps aux | grep $process | awk '{print \$2}\')\n"
	e_success "Mataste $process"
	e_arrow "ps aux | grep $process\n"
	ps aux | grep $process
}

function log() {
	carpeta_actual=$(basename $(pwd) | cut -d '-' -f1-2)
	echo "[ $(date +"%d-%m-%Y %H:%M:%S") ] - " >>"$carpeta_actual.log"
	nvim "$carpeta_actual.log"
}

function rot13() {
	if [ -z "$1" ]; then
		e_arrow "Damela toda: "
		read -r string
	else
		string=$1
	fi
	echo "$string" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
}

function count() {
	number=$1
	if [ -z "$2" ]; then
		unit="s"
	else
		unit=$2
	fi
	gum spin --timeout="${number}${unit}" sleep "${number}${unit}"
	notify-send "Countdown" "Countdown of $number finished" -i /usr/share/images/vendor-logos/logo.svg
}

function how-to-decrypt() {
	e_arrow "Lo primero es mirar el listado de discos"
	e_success "sudo lsblk"
	e_arrow "Una vez identificado, desencriptarlo"
	e_success "sudo cryptsetup luksOpen /dev/sdX eldisco"
	e_arrow "Montarlo"
	e_success "sudo mount /dev/mapper/eldisco /mnt/eldiscomontau"
	e_arrow "Hacer lo que tengas que hacer, desmontarlo"
	e_success "sudo umount /mnt/eldiscomontau"
	e_arrow "Volver a encriptarlo"
	e_success "sudo cryptsetup luksClose eldisco"
}

function how-to-magisk() {
	e_arrow "Lo primero es actualizar el dispositivo"
	e_arrow "Luego, descargar la imagen boot al dispositivo"
	e_arrow "https://download.lineageos.org/devices/enchilada/builds"
	e_arrow "Patchear la imagen"
	e_arrow "Copiar la imagen patcheada al pc"
	e_success "sudo adb pull /sdcard/Download/magisk_patched-XXXX.img"
	e_arrow "Reinciar a fastboot"
	e_arrow "Flashear la imagen patcheada"
	e_success "sudo fastboot flash boot magisk_patched-XXXX.img"
	e_arrow "Reiniciar"
}

function how-to-windows-on-grub() {
	e_arrow "Check the /etc/default/grub"
	e_arrow "GRUB_DISABLE_OS_PROBER=false"
	e_arrow "sudo update-grub"
}

function how-to-gpg() {
	e_arrow "gpg --list-secret-keys --keyid-format LONG"
	while IFS= read -r line; do
		while IFS= read -r line2; do
			echo "$line $line2"
		done < <(gpg --list-secret-keys --keyid-format LONG | grep "@" | awk '-F<' '{print $2}')
	done < <(gpg --list-secret-keys --keyid-format LONG | grep "sec" | awk '{print $2}' | awk -F/ '{print $2}')
}

function only_wpa() {
	input_file=$1
	output_file=$2
	awk 'length($0) >=  8' "$input_file" >"$output_file"
}

function write_temp(){
	# Crear un archivo temporal
	TEMP_FILE=$(mktemp)
	# Desactivar la creación de archivos de respaldo, intercambio y deshacer
	nvim --cmd "set nobackup" --cmd "set noswapfile" --cmd "set noundofile" "$TEMP_FILE"
	# Eliminar el archivo temporal
	rmk "$TEMP_FILE"
}
