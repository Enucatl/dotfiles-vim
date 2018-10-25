# Install

Config files can be backed up to a tar archive with the `rake backup` task.
They will be saved to `~/dotfiles.vim.backup.tar`.

    sudo apt install rake git
    cd
    git clone --recursive git@github.com:Enucatl/dotfiles-vim.git .vim
    cd .vim
    rake backup
    rake


# Vim plugins
## Installed plugins

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
- [vim-abolish](https://github.com/tpope/vim-abolish) `:%Subvert/facilit{y,ies}/building{,s}/g`
From a conceptual level, one way to think about how this substitution works
is to imagine that in the braces you are declaring the requirements for
turning that word from singular to plural. In the facility example, the same
base letters in both the singular and plural form of the word are facilit To
turn "facility" to a plural word you must change the y to ies so you specify
`{y,ies}` in the braces.
- [vim-ag](https://github.com/rking/ag.vim) use [the silver searcher](https://github.com/ggreer/the_silver_searcher) in vim with `:Ag`
- [vim-bundler](https://github.com/tpope/vim-bundler) Run ruby bundle from vim syntax
- [vim-coffee-script](https://github.com/kchmck/vim-coffee-script) coffeescript syntax
- [vim-colors-solarized](https://github.com/altercation/vim-colors-solarized) the solarized colorscheme
- [vim-dispatch](https://github.com/tpope/vim-dispatch) Kick off builds and
    test suites asynchronously with `:Dispatch` (also mapped to `F9`)
- [vim-eunuch](https://github.com/tpope/vim-eunuch) Vim sugar for the UNIX
    shell commands that need it the most. `:Remove`, `:SudoWrite`,
    `:Mkdir`...
- [vim-fugitive](https://github.com/tpope/vim-fugitive) git commands from inside vim
- [vim-haml](https://github.com/tpope/vim-haml) haml syntax
- [vim-javascript](https://github.com/pangloss/vim-javascript.git) javascript syntax
- [vim-latex](https://github.com/Enucatl/vim-latex) the LaTeX suite
- [vim-less](https://github.com/groenewege/vim-less) less syntax
- [vim-mako](https://github.com/sophacles/vim-bundle-mako) mako syntax
- [vim-markdown](http://plasticboy.com/markdown-vim-mode/) markdown syntax
- [vim-puppet](https://github.com/rodjek/vim-puppet) the puppet manifest syntax
- [Vim-R-plugin](https://github.com/vim-scripts/Vim-R-plugin) and [R-Vim-runtime](https://github.com/jalvesaq/R-Vim-runtime.git) for vim indenting and syntax highlighting
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

    cd ~/.vim
    git submodule init
    git submodule add git://github.com/tpope/vim-fugitive.git bundle/vim-fugitive

## Remove a plugin
`cd ~/.vim`, then use the `remove_submodule.sh` script.

    ./remove_submodule.sh bundle/unwanted_plugin

## Update plugins
`cd ~/.vim`, then use the `git-submodule` command.

    git submodule foreach pullifupstream

you might need to solve merge conflicts in rare cases. If you were me, you
could then also do

    git submodule foreach pushifupstream
