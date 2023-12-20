local nvim_lsp = require('lspconfig')

local configure_format_on_save = function(client, bufnr)
  vim.api.nvim_command(string.format('autocmd BufWritePre <buffer=%d> %s', bufnr, 'lua vim.lsp.buf.format({ async = false })'))
end

nvim_lsp.eslint.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,

  settings = {
    useESLintClass = true,
  },
})

nvim_lsp.gopls.setup({
  on_attach = configure_format_on_save,

  settings = {
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    gopls = {
      codelenses = {
        gc_details = false,
        generate = false,
        regenerate_cgo = false,
        test = true,
        tidy = false,
        upgrade_dependency = false,
        vendor = false,
      },
      directoryFilters = {
        "-console/node_modules",
        "-e2e-tests/node_modules",
        "-node_modules",
        "-pkg/ui/node_modules",
        "-pkg/ui/workspaces/cluster-ui/node_modules",
        "-pkg/ui/workspaces/db-console/node_modules",
      },
      gofumpt = true,
      linksInHover = false,
    },
  },
})

nvim_lsp.html.setup({
  on_attach = configure_format_on_save,
})

nvim_lsp.standardrb.setup({
  on_attach = configure_format_on_save,
})

nvim_lsp.tsserver.setup({
  settings = {
    -- https://github.com/typescript-language-server/typescript-language-server#initializationoptions
    init_options = {
      hostInfo = "nvim",
      preferences = {
        importModuleSpecifierPreference = "relative",
      },
    },
  },
})

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
