" general settings
set backupdir-=.
set clipboard=unnamed
set grepformat=%f:%l:%c:%m
set grepprg=ag\ --vimgrep\ $*
set list            " show trailing whitespace
set number          " enable line numbering
set wildmode=list:longest,full " helpful tab completion

" keyboard shortcuts
let mapleader = ','
nmap <leader>a :grep!<Space>
nmap <leader>b :FZFBuffers<CR>
nmap <leader>h :FZFHelptags<CR>
nmap <leader>t :FZFGFiles<CR>

" colorscheme
silent! colorscheme solarized

" autocommands
augroup vimrc
  autocmd!
  autocmd BufEnter,CursorHold,CursorHoldI,FocusGained * checktime
  autocmd QuickFixCmdPost * cwindow
  autocmd VimResized * wincmd =
augroup END

" language servers
lua <<END
  lspconfig = require "lspconfig"
  lspconfig.gopls.setup {}
END

" plugin settings
let g:fzf_command_prefix = 'FZF'
let g:fzf_layout = { 'down': '10' }
