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
##Installed plugins

- [vim-pathogen](https://github.com/tpope/vim-pathogen) manage the other
  plugins.
- [gundo.vim](https://github.com/sjl/gundo.vim) improved undo with a full
  undo tree.
- [nerdcommenter](https://github.com/scrooloose/nerdcommenter) comments in
  all programming languages.
- [tlib\_vim](https://github.com/tomtom/tlib_vim)
- [vim-addon-mw-utils](https://github.com/MarcWeber/vim-addon-mw-utils)
- [vim-surround](https://github.com/tpope/vim-surround) surround with
  parentheses, brackets, braces and tags.
- [a.vim](https://github.com/vim-scripts/a.vim) alternate between `.cpp` and `.h` with
  `:A`
- [vim-repeat](https://github.com/tpope/vim-repeat) powerful `.` command.
- [vim-spec-macros](https://bitbucket.org/Enucatl/vim-spec-macros) colors for certif
  spec macros.
- [ultisnips](git://github.com/Enucatl/ultisnips) code snippets for many
  languages.
- [vim-haskellmode](https://github.com/lukerandall/haskellmode-vim) haskell
  tools.
- [pylint](git://github.com/orenhe/pylint.vim) check the python code with
  pylint.
- [vim-latex](git://github.com/Enucatl/vim-latex) the vim LaTeX suite.
- [vim-fugitive](git://github.com/tpope/vim-fugitive) git integration.
- [nerdtree](https://github.com/scrooloose/nerdtree) navigate project files
  inside vim.
- [autotag](https://github.com/vim-scripts/AutoTag) automatically update
  ctags upon saving a file.
- [python-indent](https://github.com/gotgenes/vim-yapif) improved python
  indentation.

## Add a plugin
Example:

    :::bash
    cd ~/.vim
    git submodule init
    git submodule add git://github.com/tpope/vim-fugitive.git bundle/vim-fugitive

## Remove a plugin
`cd ~/.vim`, then define a `submodulepath` shell variable with the folder name (no trailing slash):

    :::bash
    git config -f .git/config --remove-section submodule.$submodulepath
    git config -f .gitmodules --remove-section submodule.$submodulepath
    git rm --cached $submodulepath
    git add .gitmodules
    git commit -m "Remove submodule"
    rm -rf $submodulepath
    rm -rf .git/modules/$submodulepath
