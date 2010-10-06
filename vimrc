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
set ignorecase      " case-insensitive search
set incsearch       " search as I type
set list            " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set ruler           " show me where I am
set shiftwidth=2    " normal mode indentation commands use 2 spaces
set softtabstop=2   " insert mode tab and backspace use 2 spaces
set smartcase       " case-sensitive search if any caps
set tabstop=8       " any actual tab characters occupy 8 spaces
set wildmenu        " show a navigable menu for tab completion
set wildmode=list:longest " helpful tab completion

" syntax highlighting
syntax enable

" keyboard shortcuts
let mapleader = ','
noremap! jj <ESC>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
nmap <leader>w :call whitespace#strip_trailing()<CR>
" experiment with duff's rails.vim mappings
nnoremap <leader><leader>c :Rcontroller 
nnoremap <leader><leader>m :Rmodel 
nnoremap <leader><leader>a :Rmailer 
nnoremap <leader><leader>v :Rview 
nnoremap <leader><leader>h :Rhelper 
nnoremap <leader><leader>i :Rinitializer 
nnoremap <leader><leader>e :Renvironment 
nnoremap <leader><leader>l :Rlib 
nnoremap <leader><leader>f :Rfeature 
nnoremap <leader><leader>u :Runittest 
nnoremap <leader><leader>j :Rjavascript 
nnoremap <leader><leader>t :Rtask 
nnoremap <leader><leader>r :Rspec 
" use real regular expressions when searching
nnoremap / /\v
vnoremap / /\v

" gui settings
if has('gui_running')
  colorscheme twilight

  set columns=164       " new windows shouldn't inherit previous width
  set cursorline        " highlight current line
  set fuoptions=maxvert,maxhorz
  set guifont=Menlo:h12 " Menlo has italics
  set guioptions=a      " selection->clipboard
  set number            " enable line numbering
  set transp=5          " = 95% opacity
endif

" plugin settings
let g:CommandTMaxHeight=20
