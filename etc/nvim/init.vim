" keyboard shortcuts
let mapleader = ','
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>

" colorscheme
silent! colorscheme solarized

" language servers
lua <<END
  lspconfig = require "lspconfig"
  lspconfig.gopls.setup {}
END
