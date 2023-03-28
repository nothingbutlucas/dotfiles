yt_lucky() {
    mpv --no-video $(ddgr -n 1 -x -w youtube.com $1 | grep 'https://www.youtube.com/watch?v=.*')
}

permissions_linux()
{

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

function lss()
{
    if [[ $# = 1 ]]; then
        lsd $1 --sort time
    else
        e_arrow "Adonde tiramos el lss?: "
        read folder
        lsd $folder --sort time
    fi
}

function mcd()
{
  if [[ $# = 1 ]];then
    mkdir -p $1
    cd $1
  else
    e_arrow "Nombre de nueva carpeta: "
    read folder
    mkdir -p $folder
    cd $folder
  fi
}

function pwdd()
{
  pwd
  pwd | xclip -sel clip >/dev/null 2>&1
  e_success " [ + ] Ruta copiada al clipboard [ + ]"
}

function create_note()
{
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

function man()
{
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

function rmk()
{
  scrub -p dod $1
  shred -zun 10 -v $1
}

function porcentaje()
{
    if [[ $# = 2 ]]; then
        porcentaje=$(( ($1*100) / $2 ))

        e_success "$1 es el $porcentaje % de $2"

    else
        e_arrow "Decime el primer numero que sera un porcentaje del segundo"
        read numero_1
        e_arrow "Pasame el segundo numero"
        read numero_2

        porcentaje=$(( ($numero_1*100) / $numero_2 ))

        e_success "$numero_1 es el $porcentaje % de $numero_2"

    fi
}

timezsh() {
    shell=${1-$SHELL}
    for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

alerta(){
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

mv_pritty(){
    string=$(echo $1 | sed 's/ /_/g')
    mv $1 ${string:l}
    e_success "Archivo renombrado a ${string:l}"
}

cp_and_notify(){
    cp -rp $1 $2
    curl -H "Title: PC" -H "tags: computer" -H "Priority: high" -d "Se copio correctamente $1 a $2" ntfy.sh/$TOPICO_CP
}

search_in_all_folders(){
  if [ -z "$1" ]; then
    e_arrow "Que quieres buscar?\n"
    read search
  else
    search=$1
  fi

  for directory in $(ls -d */); do
    cd $directory
    found=$((cat * | grep -i $search) 2> /dev/null)
    if [ -n "$found" ]; then
      e_success "encontrado $found en $directory"
      e_success "\n$found\n"
    fi
    found=$((ls -la | grep -i $search) 2> /dev/null)
    if [ -n "$found" ]; then
      e_success "encontrado $found en $directory"
      e_success "\n$found\n"
    fi
    cd ..
  done
}

kill-ps() {
    if [ -z "$1" ]; then
        e_arrow "Que proceso quieres matar?\n"
        read process
    else
        process=$1
    fi
    sudo kill -9 $(ps aux | grep $process | awk '{print $2}')
    e_arrow "\$(ps aux | grep $process | awk '{print \$2}\')\n"
    e_success "Mataste $process"
    e_arrow "ps aux | grep $process\n"
    ps aux | grep $process
}
