# Install
Try it now: it will back up your dotfiles before overwriting anything!
Just restore `~/.dotfiles.backup.tar` if you don't like these settings.

    :::bash
    cd; tar cf .dotfiles.backup.tar .vim
    git clone https://bitbucket.org/Enucatl/dotfiles-vim.git .vim
    cd .vim
    make backup  
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
- [nerdtree](https://github.com/scrooloose/nerdtree) navigate the project
  files on a side bar
- [tlib\_vim](https://github.com/tomtom/tlib_vim)
- [vim-addon-mw-utils](https://github.com/MarcWeber/vim-addon-mw-utils)
- [vim-surround](https://github.com/tpope/vim-surround) surround with
  parentheses, brackets, braces and tags.
- [a.vim](https://github.com/vim-scripts/a.vim) alternate between `.cpp` and
  `.h` with `:A`
- [vim-repeat](https://github.com/tpope/vim-repeat) powerful `.` command.
- [vim-spec-macros](https://bitbucket.org/Enucatl/vim-spec-macros) colors for certif
  spec macros.
- [ultisnips](git://github.com/Enucatl/ultisnips) code snippets for many
  languages.
- [hasksyn](https://github.com/travitch/hasksyn) haskell syntax and
  indentation.
- [vim-latex](git://github.com/Enucatl/vim-latex) the vim LaTeX suite.
- [vim-fugitive](git://github.com/tpope/vim-fugitive) a Git wrapper so
  awesome, it should be illegal.
- [nerdtree](https://github.com/scrooloose/nerdtree) navigate project files
  inside vim.
- [autotag](https://github.com/vim-scripts/AutoTag) automatically update
  ctags upon saving a file.
- [python-indent](https://github.com/gotgenes/vim-yapif) improved python
  indentation.
- [vim-ag](https://github.com/rking/ag.vim) use the silver searcher in vim with `:Ag`
- [vim-colors-solarized](https://github.com/altercation/vim-colors-solarized) the solarized colorscheme
- [syntastic](https://github.com/scrooloose/syntastic) automatic syntax
  checks upon save for many file types.
- [vim-speeddating](https://github.com/tpope/vim-speeddating) use CTRL-A/CTRL-X to increment dates, times, and more
- [vim-unimpaired](https://github.com/tpope/vim-unimpaired) ]q is :cnext, [q
  is :cprevious ... and more
- [ctrlP](http://kien.github.io/ctrlp.vim/) Full path fuzzy file, buffer, mru, tag, ... finder for Vim.


## Add a plugin
Example:

    :::bash
    cd ~/.vim
    git submodule init
    git submodule add git://github.com/tpope/vim-fugitive.git bundle/vim-fugitive

## Remove a plugin
`cd ~/.vim`, then use the `remove_submodule.sh` script.

    :::bash
    ./remove_submodule.sh bundle/unwanted_plugin
