" keyboard shortcuts
let mapleader = ','
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>

" colorscheme
silent! colorscheme solarized

" language servers
lua <<EOF
require('lspconfig').gopls.setup{}
EOF
