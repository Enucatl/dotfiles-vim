set nocompatible

"load pathogen from the submodules
runtime bundle/vim-pathogen/autoload/pathogen.vim

set background=light
set history=2000
syntax enable
set foldenable
"set hlsearch
set autoindent
set smartindent
set autowrite
set nojoinspaces
set shiftround
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
filetype plugin indent on
set cindent
set expandtab
set backspace=indent,eol,start
set noerrorbells
set magic
set showmatch
set showmode
set textwidth=76
set linebreak
set wildignore=*.swp,*.bak,*.pyc,*.pdf,*.idx,*.ps,*.dvi
set suffixes=.pdf,.aux,.bak,.dvi,.gz,.idx,.log,.ps,.swp,.tar
map <S-m> :!make<CR>
set virtualedit=all
nnoremap <silent> <F8> :TlistToggle <CR>
let Tlist_Exit_OnlyWindow=1
set hidden
set foldmethod=indent
"LaTeX Suite options:
set grepprg=grep\ -nH\ $*
set wmh=0
let g:tex_flavor='latex'
let mapleader=','
"set iskeyword+=:
"
"Backup options:
set undolevels=1000 "maximum number of changes that can be undone
"
"
"" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

set pastetoggle=<F3> 
nnoremap <F5> :GundoToggle<CR>

call pathogen#infect()

" for VIM-latex-suite usage
let g:Tex_MultipleCompileFormats = 'dvi,ps'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_FormatDependency_ps='dvi,ps'
let g:Tex_FormatDependency_pdf='dvi,ps,pdf'
let g:Tex_CompileRule_dvi='latex --interaction=nonstopmode $*'
let g:Tex_CompileRule_ps='dvips -o $*.ps $*.dvi'
let g:Tex_CompileRule_pdf='ps2pdf $*.ps'
let g:Tex_ViewRule_pdf='okular'

"Haskell
" use ghc functionality for haskell files
au Bufenter *.hs compiler ghc
let g:haddock_browser = "firefox"


"python pylint
autocmd FileType python compiler pylint


"Delete in normal mode to switch off highlighting till next search and clear messages...
nmap <silent> <BS> [Cancel highlighting] :nohlsearch <CR>

" Forward/back one file...
nmap <DOWN> :bn<CR>0
nmap <UP> :bp<CR>0

" avoid C-j clash between ultisnips and vim-latex
imap <C-j> <Plug>IMAP_JumpForward

" NERD_tree config
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\~$']
let NERDTreeShowBookmarks=1
map <F3> :NERDTreeToggle<CR>

"ctags
"A-] - Open the definition in a vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
