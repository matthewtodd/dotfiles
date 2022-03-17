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

-- https://github.com/neovim/nvim-lspconfig/#keybindings-and-completion
-- :help lsp-buf for more
local configure_defaults = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>A', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>c', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>d', '<cmd>lua vim.lsp.diagnostics.show_line_diagnostics()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap=true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap=true })
end

local configure_format_on_save = function(client, bufnr, command)
  vim.api.nvim_command(string.format('autocmd BufWritePre <buffer=%d> %s', bufnr, command or 'lua vim.lsp.buf.formatting_sync()'))
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
nvim_lsp.eslint.setup({
  on_attach = function(client, bufnr)
    configure_format_on_save(client, bufnr, 'EslintFixAll')
  end,
})

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
nvim_lsp.gopls.setup({
  on_attach = function(client, bufnr)
    configure_defaults(client, bufnr)
    configure_format_on_save(client, bufnr)
  end,

  settings = {
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    gopls = {
      codelenses = {
        tidy = false,
        upgrade_dependency = false,
        vendor = false,
      },
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

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver
nvim_lsp.tsserver.setup({
  on_attach = configure_defaults,
  settings = {
    -- https://github.com/typescript-language-server/typescript-language-server#initializationoptions
    init_options = {
      hostInfo = "nvim",
    },
  },
})

-- vim:et:sw=2:ts=2
