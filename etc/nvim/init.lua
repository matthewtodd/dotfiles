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

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

-- autocommands
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'CursorHoldI', 'FocusGained' }, {
  command = 'checktime',
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.go',
  callback = function(ev)
    vim.opt_local.listchars = { tab = '  ', trail = '·' , nbsp = '␣' }
    vim.opt_local.tabstop = 4
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
-- use mason-lspconfig for the ones whose versions needn't vary by project
require('mason').setup()

require('mason-lspconfig').setup {
  -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
  ensure_installed = {
    'html',
    'tsserver',
  },
}

require('mason-update-all').setup()

-- These are made available by projects that use them.
require('lspconfig').eslint.setup {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'EslintFixAll',
    })
  end,
}

-- textDocument/diagnostic support until 0.10.0 is released
_timers = {}
local function setup_diagnostics(client, buffer)
  if require("vim.lsp.diagnostic")._enable then
    return
  end

  local diagnostic_handler = function()
    local params = vim.lsp.util.make_text_document_params(buffer)
    client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
      if err then
        local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
        vim.lsp.log.error(err_msg)
      end
      local diagnostic_items = {}
      if result then
        diagnostic_items = result.items
      end
      vim.lsp.diagnostic.on_publish_diagnostics(
        nil,
        vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
        { client_id = client.id }
      )
    end)
  end

  diagnostic_handler() -- to request diagnostics on buffer when first attaching

  vim.api.nvim_buf_attach(buffer, false, {
    on_lines = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
      _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
    end,
    on_detach = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
    end,
  })
end

require('lspconfig').ruby_lsp.setup({
  on_attach = function(client, buffer)
    setup_diagnostics(client, buffer)
    add_ruby_deps_command(client, buffer)
  end,
})

require('lspconfig').sorbet.setup {}

-- vim:et:sw=2:ts=2
