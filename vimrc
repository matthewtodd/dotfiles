" set up pathogen, http://github.com/tpope/vim-pathogen
filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

" don't bother with vi compatibility
set nocompatible

" general settings
set autoindent
set autoread        " reload files when changed on disk, i.e. via `git checkout`
set encoding=utf-8
set expandtab       " expand tabs to spaces
set list            " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set ruler           " show me where I am
set shiftwidth=2    " normal mode indentation commands use 2 spaces
set softtabstop=2   " insert mode tab and backspace use 2 spaces
set tabstop=8       " any actual tab characters occupy 8 spaces
set wildmenu        " show a navigable menu for tab completion
set wildmode=list:longest " helpful tab completion

syntax enable

let mapleader = ','
nmap <Leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
nmap <Leader>f :NERDTreeFind<CR>

" move around splits more easily
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" thanks to http://vimcasts.org/e/4
function! <SID>StripTrailingWhitespace()
  let previous_search=@/
  let previous_cursor_line=line('.')
  let previous_cursor_column=col('.')
  %s/\s\+$//e
  let @/=previous_search
  call cursor(previous_cursor_line, previous_cursor_column)
endfunction

" strip trailing whitespace on F5 and ruby buffer saves
nnoremap <silent> <F5> :call <SID>StripTrailingWhitespace()<CR>
autocmd BufWritePre *.rb call <SID>StripTrailingWhitespace()
