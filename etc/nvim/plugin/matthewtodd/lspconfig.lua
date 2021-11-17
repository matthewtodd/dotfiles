local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_autocmd(event, cmd)
    vim.api.nvim_command(string.format('autocmd %s <buffer=%d> %s', event, bufnr, cmd))
  end

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_autocmd('BufWritePre', 'lua vim.lsp.buf.formatting_sync()')

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=false }
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', '<leader>A', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap('n', '<leader>c', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>d', '<cmd>lua vim.lsp.diagnostics.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
end

nvim_lsp.gopls.setup({
  on_attach = on_attach,
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
