" don't bother with vi compatibility
set nocompatible

" set up Vundle, http://github.com/gmarik/Vundle.vim
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'altercation/vim-colors-solarized'
Plugin 'austintaylor/vim-indentobject'
Plugin 'gmarik/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-scripts/Align'
source ~/.vimrc.plugins.local " include extra plugins I only care for at work
call vundle#end()
filetype plugin indent on

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

" don't bother prompting to open these files.
set wildignore=log/**,tmp/**,*.rbc

" syntax highlighting
syntax enable

" keyboard shortcuts
let mapleader = ','
noremap! jj <ESC>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nmap <leader>a :Ag<Space>
nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
nmap <leader>l :Align<Space>
nmap <leader>] :TagbarToggle<CR>
nmap <leader><space> :StripWhitespace<CR>

" gui settings
if (&t_Co == 256 || has('gui_running'))
  colorscheme solarized
endif

" rebalance windows when vim's available space changes
autocmd VimResized * wincmd =

" plugin settings
let g:ctrlp_map = '<leader>t'
