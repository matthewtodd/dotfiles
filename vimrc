set nocp " disable vi compatibility mode
filetype plugin on

set autoindent
set expandtab " expand tabs to spaces
set shiftwidth=2
set tabstop=2

syntax enable

" strip trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" recognize Capfile, Gemfile
autocmd BufRead,BufNewFile Capfile set filetype=ruby
autocmd BufRead,BufNewFile Gemfile set filetype=ruby

" use subdirectories under ~/.vim
"
" The docs (:help runtimepath) discourage wildcards for performance reasons,
" but so far YAGNI and DRY are winning.
"
" I still need to figure out how to keep from saying :helptags
" ~/.vim/PLUGIN/doc every time I update a plugin.
set runtimepath=~/.vim/*,$VIMRUNTIME

" Type ,d in normal mode to show/hide NERDTree. Super useful!
nmap ,d :NERDTreeToggle<Enter>
