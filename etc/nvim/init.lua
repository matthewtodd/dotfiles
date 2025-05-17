-- my stuff
local matthewtodd = require('matthewtodd')

-- general settings
vim.opt.background = 'light'
vim.opt.backupdir:remove({ '.' })
vim.opt.clipboard = 'unnamedplus'
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.hlsearch = false
vim.opt.list = true
vim.opt.listchars = { tab = '→ ', trail = '·', nbsp = '␣' }
vim.opt.number = true
vim.opt.scrolloff = 10
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = false
vim.opt.updatetime = 250
vim.opt.wildmode = 'list:longest,full'
vim.opt.winborder = 'rounded'

-- colorscheme
vim.cmd.colorscheme('solarized')

-- keyboard shortcuts
local telescope = require('telescope.builtin')

vim.g.mapleader = ' '

vim.keymap.set('n', "<leader>'", telescope.resume)
vim.keymap.set('n', '<leader>/', telescope.live_grep)
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action)
vim.keymap.set('v', '<leader>a', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>b', telescope.buffers)
vim.keymap.set('n', '<leader>d', telescope.diagnostics)
vim.keymap.set('n', '<leader>f', telescope.git_files)
vim.keymap.set('n', '<leader>h', telescope.help_tags)
vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>l', matthewtodd.run_nearest_codelens)
vim.keymap.set('n', '<leader>L', matthewtodd.rerun_latest_codelens)
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>s', telescope.lsp_document_symbols)
vim.keymap.set('n', '<leader>S', telescope.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')
vim.keymap.set('n', 'gd', telescope.lsp_definitions)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gi', telescope.lsp_implementations)
vim.keymap.set('n', 'gr', telescope.lsp_references)
vim.keymap.set('n', 'gy', telescope.lsp_type_definitions)

-- autocommands
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'CursorHoldI', 'FocusGained' }, {
  command = 'checktime',
})

vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  callback = function()
    vim.diagnostic.open_float()
  end
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = matthewtodd.on_lsp_attach,
})

-- A mighty hack!
-- https://github.com/nvim-telescope/telescope.nvim/issues/3436#issuecomment-2756267300
-- I tried setting telescope's defaults.border = false, but code actions
-- windows were still broken.
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopeFindPre",
  callback = function()
    vim.opt_local.winborder = "none"
    vim.api.nvim_create_autocmd("WinLeave", {
      once = true,
      callback = function()
        vim.opt_local.winborder = "rounded"
      end,
    })
  end,
})

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  command = 'setlocal nonumber',
})

vim.api.nvim_create_autocmd({ 'VimResized' }, {
  command = 'wincmd =',
})

-- plugin settings
require('blink.cmp').setup {
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },

  signature = { enabled = true },

  sources = {
    -- add lazydev to your completion providers
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
    },
  }
}

require('lazydev').setup()

require('telescope').setup {
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_cursor {}
    }
  },
}
require('telescope').load_extension('fzf')
require("telescope").load_extension('ui-select')

-- language servers
local capabilities = require('blink.cmp').get_lsp_capabilities()

require('lspconfig').eslint.setup({
  capabilities = capabilities,
})

require('lspconfig').lua_ls.setup({
  capabilities = capabilities,
})

require('lspconfig').ruby_lsp.setup({
  cmd = { "bundle", "exec", "ruby-lsp" },
  capabilities = capabilities,
  ---@diagnostic disable-next-line: unused-local
  on_attach = function(client, buffer)
    -- Prefer the symbols provided by Sorbet, since they seem faster and Telescope can't handle both.
    -- https://www.reddit.com/r/neovim/comments/zksmsa/telescope_lsp_dynamic_workspace_symbol_broken/
    client.server_capabilities.workspaceSymbolProvider = false
  end,
})

require('lspconfig').sorbet.setup({
  capabilities = capabilities,
})

require('typescript-tools').setup({
  capabilities = capabilities,
})

vim.lsp.commands['rubyLsp.runTestInTerminal'] = function(command)
  matthewtodd.register_codelens_run('rubyLsp.runTestInTerminal', command)
  vim.fn['test#strategy#neovim_sticky'](command.arguments[3])
  vim.cmd('wincmd =')
end

-- vim:et:sw=2:ts=2
