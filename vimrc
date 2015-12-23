" don't bother with vi compatibility
set nocompatible

" do not want
let g:loaded_AlignMapsPlugin = 1

" set up Vundle, http://github.com/gmarik/Vundle.vim
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'altercation/vim-colors-solarized'
Plugin 'austintaylor/vim-indentobject'
Plugin 'gmarik/Vundle.vim'
Plugin 'jgdavey/tslime.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/Align'
source ~/.vimrc.plugins.local " include extra plugins I only care for at work
call vundle#end()

" general settings
set backupcopy=yes  " see :help crontab
set directory-=.    " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab       " expand tabs to spaces
set ignorecase      " case-insensitive search
set list            " show trailing whitespace
set number          " enable line numbering
set shiftwidth=2    " normal mode indentation commands use 2 spaces
set softtabstop=2   " insert mode tab and backspace use 2 spaces
set smartcase       " case-sensitive search if any caps
set tabstop=8       " any actual tab characters occupy 8 spaces
set wildmode=list:longest " helpful tab completion

" don't bother prompting to open these files.
set wildignore=log/**,tmp/**,*.rbc

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
nmap <leader>rd :call RunNearestSpec()<CR>
nmap <leader>rs :call RunCurrentSpecFile()<CR>
nmap <leader>ra :call RunAllSpecs()<CR>
nmap <leader>t :CtrlP<CR>
nmap <leader>] :TagbarToggle<CR>
nmap <leader><space> :StripWhitespace<CR>

" gui settings
if (&t_Co == 256 || has('gui_running'))
  colorscheme solarized
endif

" rebalance windows when vim's available space changes
autocmd VimResized * wincmd =

" plugin settings
let g:better_whitespace_enabled = 0
let g:ctrlp_map = ''
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_working_path_mode = 0
let g:rspec_command = 'call Send_to_Tmux("clear\nrspec {spec}\n")'
