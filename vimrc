" use subdirectories under ~/.vim
"
" The docs (:help runtimepath) discourage wildcards for performance reasons,
" but so far YAGNI and DRY are winning.
"
" I still need to figure out how to keep from saying :helptags
" ~/.vim/PLUGIN/doc every time I update a plugin.
" http://github.com/tpope/vim-pathogen is probably what I want, but it's not
" yet clear to me how I would hook that in here.
"
" Note that the runtimepath must be set *before* calling filetype plugin on if
" filetypes are to be recognized by plugins
set runtimepath=~/.vim/*,$VIMRUNTIME

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

" Type ,d in normal mode to show/hide NERDTree. Super useful!
nmap ,d :NERDTreeToggle<Enter>
