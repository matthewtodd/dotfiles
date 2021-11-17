local nvim_lsp = require('lspconfig')

local configure_defaults = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>A', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>c', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>d', '<cmd>lua vim.lsp.diagnostics.show_line_diagnostics()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap=true })
end

local configure_format_on_save = function(client, bufnr, command)
  vim.api.nvim_command(string.format('autocmd BufWritePre <buffer=%d> %s', bufnr, command or 'lua vim.lsp.buf.formatting_sync()'))
end


nvim_lsp.gopls.setup({
  on_attach = function(client, bufnr)
    configure_defaults(client, bufnr)
    configure_format_on_save(client, bufnr)
  end,

  settings = {
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    gopls = {
      crlfmt = true,
      directoryFilters = {
        "-console/node_modules",
        "-e2e-tests/node_modules",
        "-node_modules",
        "-pkg/ui/node_modules",
        "-pkg/ui/workspaces/cluster-ui/node_modules",
        "-pkg/ui/workspaces/db-console/node_modules",
      },
      linksInHover = false,
    },
  },
})

-- vim: et sw=2 ts=2
