" don't bother with vi compatibility
set nocompatible

" set up vim-plug, https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'altercation/vim-colors-solarized'
Plug 'austintaylor/vim-indentobject'
Plug 'google/vim-ft-bzl'
Plug 'jgdavey/tslime.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'majutsushi/tagbar'
Plug 'nono/vim-handlebars'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'slim-template/vim-slim'
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'uarun/vim-protobuf'
Plug 'vim-ruby/vim-ruby'
call plug#end()

" general settings
set backupcopy=yes  " see :help crontab
set clipboard=unnamed
set directory-=.    " don't store swapfiles in the current directory
set grepformat=%f:%l:%c:%m
set grepprg=ag\ --vimgrep\ $*
set list            " show trailing whitespace
set nohlsearch
set number          " enable line numbering
set ttimeoutlen=-1  " https://github.com/neovim/neovim/issues/2017#issuecomment-75223935
set wildmode=list:longest,full " helpful tab completion

" don't bother prompting to open these files.
set wildignore=log/**,tmp/**,*.rbc

" keyboard shortcuts
let mapleader = ','
nmap <leader>a :grep!<Space>
nmap <leader>b :FZFBuffers<CR>
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
nmap <leader>rd :call RunNearestSpec()<CR>
nmap <leader>rs :call RunCurrentSpecFile()<CR>
nmap <leader>ra :call RunAllSpecs()<CR>
nmap <leader>t :FZFFiles<CR>
nmap <leader>] :TagbarToggle<CR>
nmap <leader><space> :StripWhitespace<CR>
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" gui settings
if (&t_Co == 256 || has('gui_running'))
  silent! colorscheme solarized
endif

" autocommands
augroup vimrc
  autocmd!
  autocmd BufEnter *.dot set makeprg=dot\ -Tpng\ %
  autocmd BufEnter *.msc set makeprg=mscgen\ -Tpng\ %
  autocmd QuickFixCmdPost * cwindow
  autocmd VimResized * wincmd =
augroup END

" plugin settings
let g:better_whitespace_enabled = 0
let g:fzf_command_prefix = 'FZF'
let g:fzf_layout = { 'down': '10' }
let g:rspec_command = 'call Send_to_Tmux("clear\nrspec {spec}\n")'
