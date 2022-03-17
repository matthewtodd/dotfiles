" general settings
set backupdir-=.
set clipboard=unnamed
set grepformat=%f:%l:%c:%m
set grepprg=ag\ --vimgrep\ $*
set list
set listchars=tab:→\ ,trail:·,nbsp:␣
set number
set wildmode=list:longest,full

" keyboard shortcuts
let mapleader = ','
nmap <leader>a :grep!<Space>
nmap <leader>b :FZFBuffers<CR>
nmap <leader>h :FZFHelptags<CR>
nmap <leader>t :FZFGFiles<CR>

" colorscheme
" I wrote this solarized scheme to work regardless of background, but for some
" reason, when the Terminal has a dark background, NeoVim falls back to the
" default colorscheme. Setting background to light (or dark, for that matter)
" somehow keeps NeoVim choosing solarized.
set background=light
silent! colorscheme solarized

" autocommands
augroup vimrc
  autocmd!
  autocmd BufEnter,CursorHold,CursorHoldI,FocusGained * checktime
  autocmd BufNewFile,BufRead *.go setlocal tabstop=4 listchars=tab:\ \ ,trail:·,nbsp:␣
  autocmd QuickFixCmdPost * cwindow
  autocmd VimResized * wincmd =
augroup END

" plugin settings
let g:fzf_command_prefix = 'FZF'
let g:fzf_layout = { 'down': '10' }
