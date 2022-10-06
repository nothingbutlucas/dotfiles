#!/usr/bin/env sh

echo -e "Vamos a crear la carpeta para los plugins de la zsh"

sudo mkdir -p /usr/share/zsh-plugins/

echo -e "Me descargo los plugins de la zsh"

cd /usr/share/zsh-plugins/

echo -e "Voy a necesitar permisos de sudo para poder descargar los plugins de la zsh en /usr/share/zsh-plugins/"

sudo wget -b -t 5 "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh"
sudo wget -b -t 5 "https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh"
sudo wget -b -t 5 "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/jsontools/jsontools.plugin.zsh"
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

echo -e "Ahora queda instalar la zshrc y la powerlevel10k"

system=$( cat /etc/os-release | grep -i "ID=" | cut -d "=" -f 2 | head -n 1 )

if [ $system = "fedora" || $system = "rhel" ]; then
    package="dnf"
elif [ $system = "debian" || $system = "ubuntu" ]; then
    package="apt"
else
    echo -e "No se ha podido reconocer el sistema :("
    exit 1
fi

echo "El sistema es fedora o rhel"
sleep 0.5
echo "Instalando zsh..."
sleep 0.5
sudo $package install zsh -y
echo "Instalando powerlevel10k..."
sleep 0.5
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
echo -e "Instalando mpv"
sleep 0.5
sudo $package install mpv -y
echo -e "Instalando youtube-dl"
sleep 0.5
sudo $package install youtube-dl -y

