colorscheme twilight

" make the after-the-buffer background the same as the in-the-buffer
" background; it's far less distracting that way.
hi NonText guibg=#141414

" make text-based tabs blend in
hi! link TabLine StatusLineNC
hi! link TabLineFill StatusLineNC
hi! link TabLineSel StatusLine

set columns=164       " new windows shouldn't inherit previous width
set cursorline        " highlight current line
set fuoptions=maxvert,maxhorz
set guifont=Menlo:h12 " Menlo has italics
set guioptions=a      " selection->clipboard
set number            " enable line numbering
