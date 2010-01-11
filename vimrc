set nocp " disable vi compatibility mode
filetype plugin on

set expandtab " expand tabs to spaces
set tabstop=2
set shiftwidth=2

syntax enable

" strip trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

