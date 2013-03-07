Installation:

    :::bash
    git clone git://github.com/nelstrom/dotvim.git ~/.vim

Create symlinks:

    :::bash
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc

Switch to the `~/.vim` directory, and fetch submodules:

    :::bash
    cd ~/.vim
    git submodule init
    git submodule update

