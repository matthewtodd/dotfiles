" don't bother with vi compatibility
set nocompatible

" early set up various paths roughly according to the XDG spec
" I assume we could remove these if ever moving to neovim
" https://wiki.archlinux.org/index.php/XDG_Base_Directory
call mkdir($XDG_CACHE_HOME . '/vim/backup', 'p')
call mkdir($XDG_CACHE_HOME . '/vim/swap', 'p')
call mkdir($XDG_CACHE_HOME . '/vim/undo', 'p')

set backupdir=$XDG_CACHE_HOME/vim/backup
set directory=$XDG_CACHE_HOME/vim/swap
set runtimepath=$XDG_DATA_HOME/vim,$VIMRUNTIME
set undodir=$XDG_CACHE_HOME/vim/undo
set viminfofile=$XDG_CACHE_HOME/vim/viminfo

let g:NERDTreeBookmarksFile = $XDG_DATA_HOME . '/vim/NERDTreeBookmarks'
let g:plug_home = $XDG_DATA_HOME . '/vim/plugged'

" set up vim-plug, https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'altercation/vim-colors-solarized'
Plug 'austintaylor/vim-indentobject'
Plug 'djoshea/vim-autoread'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
call plug#end()

" general settings
set backupcopy=yes  " see :help crontab
set clipboard=unnamed
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
nmap <leader>t :FZFFiles<CR>
nmap <leader><space> :StripWhitespace<CR>

" gui settings
" https://stefan.sofa-rockers.org/2018/10/23/macos-dark-mode-terminal-vim/
function! MatchSystemDarkMode(...)
  if len(systemlist("defaults read -g AppleInterfaceStyle 2>/dev/null")) > 0
    if &background !=? "dark" " avoid flicker
      let &background = "dark"
    endif
  else
    if &background !=? "light" " avoid flicker
      let &background = "light"
    endif
  endif
endfunction

if (&t_Co == 256 || has('gui_running'))
  call MatchSystemDarkMode()
  silent! colorscheme solarized
  " icky to shell out so frequently!
  " would otherwise need vim compiled with +clientserver, which requires X11
  " https://vi.stackexchange.com/a/13579
  " https://github.com/Homebrew/homebrew-core/issues/30717
  " neovim doesn't have +clientserver:
  " https://vi.stackexchange.com/q/5348
  " and I'm wondering if this is the source of so many visual artifacts I'm
  " seeing, so commenting out for now...
  " call timer_start(3000, "MatchSystemDarkMode", {"repeat": -1}) " -1 means forever
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
