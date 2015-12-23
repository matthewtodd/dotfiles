" don't bother with vi compatibility
set nocompatible

" do not want
let g:loaded_AlignMapsPlugin = 1

" set up vim-plug, https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'altercation/vim-colors-solarized'
Plug 'austintaylor/vim-indentobject'
Plug 'jgdavey/tslime.vim'
Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/Align'
source ~/.vimrc.plugins.local " include extra plugins I only care for at work
call plug#end()

" general settings
set backupcopy=yes  " see :help crontab
set directory-=.    " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab       " expand tabs to spaces
set list            " show trailing whitespace
set number          " enable line numbering
set shiftwidth=2    " normal mode indentation commands use 2 spaces
set softtabstop=2   " insert mode tab and backspace use 2 spaces
set tabstop=8       " any actual tab characters occupy 8 spaces
set wildmode=list:longest,full " helpful tab completion

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
  silent! colorscheme solarized
endif

" rebalance windows when vim's available space changes
autocmd VimResized * wincmd =

" plugin settings
let g:better_whitespace_enabled = 0
let g:ctrlp_map = ''
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_working_path_mode = 0
let g:rspec_command = 'call Send_to_Tmux("clear\nrspec {spec}\n")'
