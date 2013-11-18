Installation:

    :::bash
    git clone git@bitbucket.org:Enucatl/dotfiles-vim.git ~/.vim

Create symlinks:

    :::bash
    ln -s ~/.vim/func_cd ~/bin/func_cd
    ln -s ~/.vim/func_mcd ~/bin/func_mcd
    ln -s ~/.vim/Rprofile ~/.Rprofile
    ln -s ~/.vim/xmobarrc ~/.xmobarrc
    ln -s ~/.vim/xmonad.hs ~/.xmonad/xmonad.hs
    ln -s ~/.vim/gitconfig ~/.gitconfig
    ln -s ~/.vim/gitignore ~/.gitignore
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc
    ln -s ~/.vim/pentadactylrc ~/.pentadactylrc
    ln -s ~/.vim/bashrc ~/.bashrc
    ln -s ~/.vim/bash_aliases ~/.bash_aliases
    ln -s ~/.vim/bash_completion ~/.bash_completion
    ln -s ~/.vim/gvim_fg ~/bin/gvim_fg

Switch to the `~/.vim` directory, and fetch submodules:

    :::bash
    cd ~/.vim
    git submodule init
    git submodule update

How to remove submodules?
Go to the ROOT of the project. Define a `submodulepath` shell variable (no trailing slash):

    :::bash
    git config -f .git/config --remove-section submodule.$submodulepath
    git config -f .gitmodules --remove-section submodule.$submodulepath
    git rm --cached $submodulepath
    git add .gitmodules
    git commit -m "Remove submodule"
    rm -rf $submodulepath
    rm -rf .git/modules/$submodulepath
