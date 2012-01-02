" set up pathogen, http://github.com/tpope/vim-pathogen
call pathogen#infect()
filetype plugin indent on

" don't bother with vi compatibility
set nocompatible

" general settings
set autoindent
set autoread        " reload files when changed on disk, i.e. via `git checkout`
set backupcopy=yes  " see :help crontab
set directory-=.    " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab       " expand tabs to spaces
set ignorecase      " case-insensitive search
set incsearch       " search as I type
set laststatus=2    " always show status line
set list            " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set number          " enable line numbering
set ruler           " show me where I am
set scrolloff=3     " show context above/below cursor line
set shiftwidth=2    " normal mode indentation commands use 2 spaces
set softtabstop=2   " insert mode tab and backspace use 2 spaces
set smartcase       " case-sensitive search if any caps
set tabstop=8       " any actual tab characters occupy 8 spaces
set wildmenu        " show a navigable menu for tab completion
set wildmode=list:longest " helpful tab completion

" don't bother prompting to open these files. also removes them from
" Command-T's listing, which is nice.
set wildignore=log/**,tmp/**

" syntax highlighting
syntax enable

" keyboard shortcuts
let mapleader = ','
noremap! jj <ESC>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nmap <leader>a :Ack 
nmap <leader>b :CommandTBuffer<CR>
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
nmap <leader>t :CommandT<CR>
nmap <leader>T :CommandTFlush<CR>:CommandT<CR>
nmap <leader><space> :call whitespace#strip_trailing()<CR>
" use real regular expressions when searching
nnoremap / /\v
vnoremap / /\v

" gui settings
if (&t_Co == 256 || has('gui_running'))
  set background=dark
  colorscheme solarized
endif

if has('gui_running')
  set columns=164       " new windows shouldn't inherit previous width
  set fuoptions=maxvert,maxhorz
  set guifont=Menlo:h12 " Menlo has italics
  set guioptions=a      " selection->clipboard
endif

" rebalance windows when vim's available space changes
autocmd VimResized * wincmd =

" plugin settings
let g:CommandTMaxHeight=20
