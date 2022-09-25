# dotfiles
An user home usefull dotfiles for aliases and that stuff

## What is this?

So, the dot files are the (<code.</code>) files like: <code>.zshrc</code>, <code>.gitconfig</code>, <code>.config/</code> directory and etc.
I save this configurations for my convenience, since if I connect to a server or install a new system and want to have my aliases handy, I just clone this repository and I'm good to go.

~~Along with the [installucas](https://github.com/nothingbutlucas/installucas) repository, I can **install** this setup **and get everything back to how it was in seconds**.~~ This is on a WIP right now...

Also, I suppose someone might find it useful or come up with some ideas to improve this.

## Installation

**Remember to make a backup of your .bashrc, .gitconfig and etc files**

    cd $HOME

    git clone https://github.com/nothingbutlucas/dotfiles/

#### Backup of your files [OptionalButNoOptional]

    cp ${HOME}/.zshrc ${HOME}/.zshrc.backup

    cp ${HOME}/.bashrc ${HOME}/.bashrc.backup

#### Symbolic link the dotfiles

    ln -s ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc ${HOME}/ && ln -s dotfiles/.bashrc ${HOME}/.bashrc

    ln -s ${HOME}/dotfiles/.tmux.conf ${HOME}/.tmux.conf

