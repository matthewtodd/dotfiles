" use subdirectories under ~/.vim/bundle
" thanks to http://github.com/tpope/vim-pathogen, via @xshay
"
" Pathogen also provides :call pathogen#helptags() to regenerate helptags for
" each of the bundled plugins as needed
"
" Note that the runtimepath must be set *before* calling filetype plugin on if
" filetypes are to be recognized by plugins
call pathogen#runtime_append_all_bundles()

filetype plugin on

set autoindent
set expandtab " expand tabs to spaces
set ruler           " show me where I am
set shiftwidth=2    " normal mode indentation commands use 2 spaces
set softtabstop=2   " insert mode tab and backspace use 2 spaces
set tabstop=2       " any actual tab characters occupy 2 spaces
set wildmode=list:longest " helpful tab completion

syntax enable

let mapleader = ','
nmap <Leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" this is nicer than directly using :%s/\s\+$//e in the autocmd because it
" leaves the cursor position and previous search highlighting unaffected.
"
" thanks to http://vimcasts.org/episodes/tidying-whitespace/
function! <SID>StripTrailingWhitespace()
  let previous_search=@/
  let previous_cursor_line=line('.')
  let previous_cursor_column=col('.')
  %s/\s\+$//e
  let @/=previous_search
  call cursor(previous_cursor_line, previous_cursor_column)
endfunction

autocmd BufWritePre * call <SID>StripTrailingWhitespace()
