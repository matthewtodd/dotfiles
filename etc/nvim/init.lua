-- general settings
vim.opt.backupdir:remove({ '.' })
vim.opt.clipboard = 'unnamed'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'ag --vimgrep $*'
vim.opt.hlsearch = false
vim.opt.list = true
vim.opt.listchars = { tab = '→ ', trail = '·' , nbsp = '␣' }
vim.opt.number = true
vim.opt.wildmode = 'list:longest,full'

-- keyboard shortcuts
vim.g.mapleader = ','
vim.keymap.set('n', '<leader>a', ':grep!<space>')
vim.keymap.set('n', '<leader>b', ':FZFBuffers<cr>')
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>h', ':FZFHelptags<cr>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>t', ':FZFGFiles<cr>')
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)


-- colorscheme
-- I wrote this solarized scheme to work regardless of background, but for some
-- reason, when the Terminal has a dark background, NeoVim falls back to the
-- default colorscheme. Setting background to light (or dark, for that matter)
-- somehow keeps NeoVim choosing solarized.
vim.opt.background = 'light'
vim.cmd.colorscheme('solarized')

-- autocommands
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'CursorHoldI', 'FocusGained' }, {
  command = 'checktime',
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.go',
  callback = function(ev)
    vim.bo[ev.buf].listchars = 'tab:  ,trail:·,nbsp:␣'
    vim.bo[ev.buf].tabstop = 4
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set({'n', 'v'}, '<leader>c', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function(ev)
        vim.lsp.buf.format { async = false }
      end
    })
  end
})

vim.api.nvim_create_autocmd({ 'QuickFixCmdPost' }, {
  command = 'cwindow',
})

vim.api.nvim_create_autocmd({ 'VimResized' }, {
  command = 'wincmd =',
})

-- plugin settings
vim.g.fzf_command_prefix = 'FZF'

-- language servers
require('mason').setup()

require('mason-lspconfig').setup {
  ensure_installed = {
    'clangd',
    'cmake',
    'eslint',
    'html',
    'tsserver',
  },

  handlers = {
    function(name)
      require('lspconfig')[name].setup {}
    end,

    ['eslint'] = function()
      require('lspconfig').eslint.setup {
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'EslintFixAll',
          })
        end,
      }
    end,
  },
}

-- vim:et:sw=2:ts=2
