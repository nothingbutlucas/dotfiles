# Plugins

FILES_STR=$(ls /usr/share/zsh-plugins/)
FILES=($(echo $FILES_STR | tr '\n' ' '))

source /usr/share/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

for FILE in $FILES;do
    source /usr/share/zsh-plugins/$FILE
done
