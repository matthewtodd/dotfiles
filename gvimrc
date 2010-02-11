set background=dark
colorscheme macvim

highlight Normal guibg=#080808     " darker background
highlight CursorLine guibg=#0f0f0f " subtler highlighting

set cursorline        " highlight current line
set guifont=Monaco:h12
set guioptions=egmt   " disable scrollbars
set number            " enable line numbering
set transp=1          " slightly transparent

function! s:GoFullscreen()
  " Make MacVim remember small values for columns and lines rather than the
  " fullscreen ones.
  set columns=80
  set lines=25

  set fuoptions=maxvert,maxhorz
  set fullscreen
endfunction

autocmd GUIEnter * call s:GoFullscreen()
