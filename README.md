#Install
Warning: it will remove your configuration files! Make sure you have a
backup.

    :::bash
    rm -rf ~/.vim
    git clone https://bitbucket.org/Enucatl/dotfiles-vim.git ~/.vim
    cd ~/.vim
    make clean
    make install

Switch to the `~/.vim` directory, and fetch submodules:

    :::bash
    cd ~/.vim
    git submodule init
    git submodule update

# Add a submodule
Example:

    :::bash
    cd ~/.vim
    git submodule init
    git submodule add git://github.com/tpope/vim-fugitive.git bundle/vim-fugitive

# Remove a submodule
`cd ~/.vim`, then define a `submodulepath` shell variable with the folder name (no trailing slash):

    :::bash
    git config -f .git/config --remove-section submodule.$submodulepath
    git config -f .gitmodules --remove-section submodule.$submodulepath
    git rm --cached $submodulepath
    git add .gitmodules
    git commit -m "Remove submodule"
    rm -rf $submodulepath
    rm -rf .git/modules/$submodulepath
