Installation:

    :::bash
    git clone git@bitbucket.org:Enucatl/dotfiles-vim.git ~/.vim

Create symlinks:

    :::bash
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc

Switch to the `~/.vim` directory, and fetch submodules:

    :::bash
    cd ~/.vim
    git submodule init
    git submodule update

