set nocompatible
set background=light
set history=2000
syntax enable
set foldenable
set foldmethod=indent
"set hlsearch
set autoindent
set smartindent
set autowrite
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
filetype plugin indent on
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
nnoremap <F8> :GundoToggle<CR>

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
