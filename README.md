# dotfiles
An user home usefull dotfiles for aliases and that stuff

## What is this?

So, the dot files are the (<code.</code>) files like: <code>.zshrc</code>, <code>.gitconfig</code>, <code>.config/</code> directory and etc.
I save this configurations for my convenience, since if I connect to a server or install a new system and want to have my aliases handy, I just clone this repository and I'm good to go.

Also, I suppose someone might find it useful or come up with some ideas to improve this.

In the dev branch I make an script to install this dot files (Make a backup of your actual dotfiles and copy the newones) and also some packages like zsh, p10k, etc. I can't guarantee that it will work 100%, but u can tryit, it works for me


## Installation

There are 2 ways, manually and by a script. But in both you have first to download this repo. My recommendation is to make a fork of this repository and download your own, so you can customize the dotfiles, it's good to be able to do it and understand how they work. From this fork you can also update the repository with the things I add to this repository.

    git clone https://github.com/nothingbutlucas/dotfiles

    cd dotfiles

### With the script on the dev branch

I'm still working on this script and I haven't tested it 100%, so maybe something is wrong, I don't know.
But you can try it if you want.
The important thing is that the backup part works perfectly.

#### Give the script execution permissions

    sudo chmod u+x install_configs.sh

#### Execute the script and first of all select backup, then do whatever u want

    ./install_configs.sh

### Manually

**Remember to make a backup of your .bashrc, .gitconfig and etc files**
(The script on the dev branch should do the trick for you)

#### Backup of your files [OptionalButNoOptional]

    mkdir -p ${HOME}/.config/dotfiles_backup

    mv ${HOME}/.zshrc ${HOME}/.config/dotfiles_backup/.zshrc

    mv ${HOME}/.bashrc ${HOME}/.config/dotfiles_backup/.bashrc

    mv ${HOME}/.tmux.conf ${HOME}/.config/dotfiles_backup/.tmux.conf

    mv ${HOME}/.gitconfig ${HOME}/.config/dotfiles_backup/.gitconfig

    mv ${HOME}/.Xdefaults ${HOME}/.config/dotfiles_backup/.Xdefaults

#### Symbolic link the dotfiles

    ln -s -n ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc

    ln -s -n ${HOME}/dotfiles/.bashrc ${HOME}/.bashrc

    ln -s -n ${HOME}/dotfiles/.tmux.conf ${HOME}/.tmux.conf

    ln -s -n ${HOME}/dotfiles/.gitconfig ${HOME}/.gitconfig

    ln -s -n ${HOME}/dotfiles/.Xdefaults ${HOME}/.Xdefaults

    ln -s -n ${HOME}/dotfiles/zshrc/aliases.sh ${HOME}/dotfiles/bashrc/aliases.sh

    ln -s -n ${HOME}/dotfiles/zshrc/utils.sh ${HOME}/dotfiles/bashrc/utils.sh

## Updates

Go to the dotfiles directory and make a <code>git pull</code>

    cd ${HOME}/dotfiles
    git pull

If you fork the repo and clone it from your repo I think that you can make something like:

    git pull
    git merge main

Or you can do it directly on github with the sync fork option.

