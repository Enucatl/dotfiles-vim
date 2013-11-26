# Install
Warning: it will remove your configuration files! Make sure you have a
backup.

    :::bash
    rm -rf ~/.vim
    git clone https://bitbucket.org/Enucatl/dotfiles-vim.git ~/.vim
    cd ~/.vim
    make clean
    make install

# Vim plugins
The following vim plugins will be installed
    - [vim-pathogen](https://github.com/tpope/vim-pathogen)
    - [gundo.vim](https://github.com/sjl/gundo.vim)
    - [nerdcommenter](https://github.com/scrooloose/nerdcommenter)
    - [tlib\_vim](https://github.com/tomtom/tlib_vim)
    - [vim-addon-mw-utils](https://github.com/MarcWeber/vim-addon-mw-utils)
    - [vim-surround](https://github.com/tpope/vim-surround)
    - [a.vim](https://github.com/vim-scripts/a.vim)
    - [vim-repeat](https://github.com/tpope/vim-repeat)
    - [vim-spec-macros](https://bitbucket.org/Enucatl/vim-spec-macros)
    - [ultisnips](git://github.com/Enucatl/ultisnips)
    - [vim-haskellmode](https://github.com/lukerandall/haskellmode-vim)
    - [pylint](git://github.com/orenhe/pylint.vim)
    - [vim-latex](git://github.com/Enucatl/vim-latex)
    - [vim-fugitive](git://github.com/tpope/vim-fugitive)
    - [nerdtree](https://github.com/scrooloose/nerdtree)
    - [autotag](https://github.com/vim-scripts/AutoTag)
    - [python-indent](https://github.com/gotgenes/vim-yapif)

# Edit the vim plugins
## Add a submodule
Example:

    :::bash
    cd ~/.vim
    git submodule init
    git submodule add git://github.com/tpope/vim-fugitive.git bundle/vim-fugitive

## Remove a submodule
`cd ~/.vim`, then define a `submodulepath` shell variable with the folder name (no trailing slash):

    :::bash
    git config -f .git/config --remove-section submodule.$submodulepath
    git config -f .gitmodules --remove-section submodule.$submodulepath
    git rm --cached $submodulepath
    git add .gitmodules
    git commit -m "Remove submodule"
    rm -rf $submodulepath
    rm -rf .git/modules/$submodulepath
