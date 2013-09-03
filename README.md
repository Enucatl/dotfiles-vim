Installation:

    :::bash
    git clone git@bitbucket.org:Enucatl/dotfiles-vim.git ~/.vim

Create symlinks:

    :::bash
    ln -s ~/.vim/gitconfig ~/.gitconfig
    ln -s ~/.vim/gitignore ~/.gitignore
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc
    ln -s ~/.vim/bashrc ~/.bashrc
    ln -s ~/.vim/bash_aliases ~/.bash_aliases
    ln -s ~/.vim/bash_completion ~/.bash_completion

Switch to the `~/.vim` directory, and fetch submodules:

    :::bash
    cd ~/.vim
    git submodule init
    git submodule update

How to remove submodules?
Define a `submodulepath` shell variable (no trailing slash):

    :::bash
    git config -f .git/config --remove-section submodule.$submodulepath
    git config -f .gitmodules --remove-section submodule.$submodulepath
    git rm --cached $submodulepath
    git add .gitmodules
    git commit -m "Remove submodule"
    rm -rf $submodulepath
    rm -rf .git/modules/$submodulepath
