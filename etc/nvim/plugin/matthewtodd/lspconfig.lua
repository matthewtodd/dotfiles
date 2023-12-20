local lspconfig = require('lspconfig')

local configure_format_on_save = function(client, bufnr)
  vim.api.nvim_command(string.format('autocmd BufWritePre <buffer=%d> %s', bufnr, 'lua vim.lsp.buf.format({ async = false })'))
end

lspconfig.eslint.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

lspconfig.gopls.setup({
  on_attach = configure_format_on_save,
})

lspconfig.html.setup({
  on_attach = configure_format_on_save,
})

lspconfig.standardrb.setup({
  on_attach = configure_format_on_save,
})

lspconfig.tsserver.setup({})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gO', vim.lsp.buf.document_symbol, opts)
    vim.keymap.set('n', '<leader>A', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', '<leader>c', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>d', vim.lsp.diagnostics.show_line_diagnostics, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
  end
})

-- vim:et:sw=2:ts=2
