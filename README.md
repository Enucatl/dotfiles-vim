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


# Color themes

The solarized colorscheme is installed for
[vim](https://github.com/altercation/vim-colors-solarized) and
[pentadactyl](https://github.com/claytron/pentadactyl-solarized). It doesn't
really fit with the other colors of firefox though.


# Vim plugins
##Installed plugins

- [autotag](https://github.com/vim-scripts/AutoTag) automatically update ctags upon saving a file
- [a.vim](https://github.com/vim-scripts/a.vim) alternate between `.cpp` and `.h` with `:A`
- [ctrlP](http://kien.github.io/ctrlp.vim/) Full path fuzzy file, buffer, mru, tag, ... finder for Vim
- [gundo.vim](https://github.com/sjl/gundo.vim) improved undo with a full undo tree on `F6`
- [hasksyn](https://github.com/travitch/hasksyn) haskell syntax
- [html5](https://github.com/othree/) update the html options with the html5 tags
- [nerdcommenter](https://github.com/scrooloose/nerdcommenter) comments in all programming languages
- [nerdtree](https://github.com/scrooloose/nerdtree) navigate project files inside vim on `F4`
- [python-indent](https://github.com/gotgenes/vim-yapif) improved python indentation
- [syntastic](https://github.com/scrooloose/syntastic) automatic syntax checks upon save
- [ultisnips](git://github.com/Enucatl/ultisnips) code snippets for many languages
- [vim-ag](https://github.com/rking/ag.vim) use [the silver searcher](https://github.com/ggreer/the_silver_searcher) in vim with `:Ag`
- [vim-bundler](https://github.com/tpope/vim-bundler) Run ruby bundle from vim syntax
- [vim-coffee-script](https://github.com/kchmck/vim-coffee-script) coffeescript syntax
- [vim-colors-solarized](https://github.com/altercation/vim-colors-solarized) the solarized colorscheme
- [vim-fugitive](git://github.com/tpope/vim-fugitive) git commands from inside vim
- [vim-haml](https://github.com/tpope/vim-haml) haml syntax
- [vim-jade](https://github.com/digitaltoad/vim-jade) jade syntax
- [vim-javascript](https://github.com/pangloss/vim-javascript.git) javascript syntax
- [vim-latex](git://github.com/Enucatl/vim-latex) the LaTeX suite
- [vim-less](https://github.com/groenewege/vim-less) less syntax
- [vim-mako](https://github.com/sophacles/vim-bundle-mako) mako syntax
- [vim-markdown](http://plasticboy.com/markdown-vim-mode/) markdown syntax
- [vim-puppet](https://github.com/rodjek/vim-puppet) the puppet manifest syntax
- [vim-ragtag](https://github.com/tpope/vim-ragtag) HTML/XML/eRuby surround tags
- [vim-rails](https://github.com/tpope/vim-rails) rails syntax
- [vim-repeat](https://github.com/tpope/vim-repeat) more powerful `.` command
- [vim-ruby](https://github.com/vim-ruby) ruby syntax
- [vim-sexp](https://github.com/guns/vim-sexp) with [mappings](https://github.com/tpope/vim-sexp-mappings-for-regular-people) for higher level definitions of text elements
- [vim-spec-macros](https://bitbucket.org/Enucatl/vim-spec-macros) certif spec macro syntax
- [vim-speeddating](https://github.com/tpope/vim-speeddating) use CTRL-A/CTRL-X to increment dates, times, and more
- [vim-surround](https://github.com/tpope/vim-surround) surround with parentheses, brackets, braces and tags
- [vim-unimpaired](https://github.com/tpope/vim-unimpaired) ]q is :cnext, [q is :cprevious ... and more

## Add a plugin

    :::bash
    cd ~/.vim
    git submodule init
    git submodule add git://github.com/tpope/vim-fugitive.git bundle/vim-fugitive


## Remove a plugin
`cd ~/.vim`, then use the `remove_submodule.sh` script.

    :::bash
    ./remove_submodule.sh bundle/unwanted_plugin
