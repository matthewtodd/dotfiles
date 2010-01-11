set nocp " disable vi compatibility mode
filetype plugin on

set autoindent
set expandtab " expand tabs to spaces
set shiftwidth=2
set tabstop=2

syntax enable

" strip trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

