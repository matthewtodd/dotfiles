function! xdg#setup(...)
  " I assume we could remove these if ever moving to neovim
  " https://wiki.archlinux.org/index.php/XDG_Base_Directory
  call mkdir($XDG_CACHE_HOME . '/vim/backup', 'p')
  call mkdir($XDG_CACHE_HOME . '/vim/swap', 'p')
  call mkdir($XDG_CACHE_HOME . '/vim/undo', 'p')

  set backupdir=$XDG_CACHE_HOME/vim/backup
  set directory=$XDG_CACHE_HOME/vim/swap
  set runtimepath+=$XDG_DATA_HOME/vim
  set undodir=$XDG_CACHE_HOME/vim/undo
  set viminfofile=$XDG_CACHE_HOME/vim/viminfo

  let g:NERDTreeBookmarksFile = $XDG_DATA_HOME . '/vim/NERDTreeBookmarks'
  let g:plug_home = $XDG_DATA_HOME . '/vim/plugged'
endfunction
