local nvim_lsp = require('lspconfig')

--[[
  Built-in Commands
  https://github.com/neovim/nvim-lspconfig/#built-in-commands

  - `:LspInfo` shows the status of active and configured language servers.
  - `:LspStart <config_name>` Start the requested server name. Will only
     successfully start if the command detects a root directory matching the
     current config. Pass autostart = false to your .setup{} call for a language
     server if you would like to launch clients solely with this command.
     Defaults to all servers matching current buffer filetype.
  - `:LspStop <client_id>` Defaults to stopping all buffer clients.
  - `:LspRestart <client_id>` Defaults to restarting all buffer clients.
--]]


local configure_format_on_save = function(client, bufnr)
  vim.api.nvim_command(string.format('autocmd BufWritePre <buffer=%d> %s', bufnr, 'lua vim.lsp.buf.format({ async = false })'))
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
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

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
-- https://github.com/bazelbuild/rules_go/wiki/Editor-setup
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

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#html
nvim_lsp.html.setup({
  on_attach = configure_format_on_save,
})

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#standardrb
nvim_lsp.standardrb.setup({
  on_attach = configure_format_on_save,
})

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver
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

    -- https://github.com/neovim/nvim-lspconfig/#keybindings-and-completion
    -- :help lsp-buf for more
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
