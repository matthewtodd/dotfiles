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
set shiftwidth=2
set tabstop=2
set wildmode=list:longest " helpful tab completion

syntax enable

" strip trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" recognize Capfile, Gemfile
autocmd BufRead,BufNewFile Capfile set filetype=ruby
autocmd BufRead,BufNewFile Gemfile set filetype=ruby

" Type ,d in normal mode to show/hide NERDTree.
nmap ,d :NERDTreeToggle<Enter>
" Type ,t in normal mode to show/hide the Taglist.
nmap ,t :TlistToggle<Enter>
