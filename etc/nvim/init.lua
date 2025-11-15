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
vim.opt.mouse = {}
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
local function picker(which)
  return function()
    Snacks.picker.pick(which)
  end
end

vim.g.mapleader = ' '

vim.keymap.set('n', "<leader>'", picker("resume"))
vim.keymap.set('n', '<leader>/', picker("grep"))
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action)
vim.keymap.set('v', '<leader>a', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>b', picker("buffers"))
vim.keymap.set('n', '<leader>d', picker("diagnostics"))
vim.keymap.set('n', '<leader>f', picker("git_files"))
vim.keymap.set('n', '<leader>h', picker("help"))
vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>l', matthewtodd.run_nearest_codelens)
vim.keymap.set('n', '<leader>L', matthewtodd.rerun_latest_codelens)
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>s', picker("lsp_symbols"))
vim.keymap.set('n', '<leader>S', picker("lsp_workspace_symbols"))
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')
vim.keymap.set('n', 'gd', picker("lsp_definitions"))
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gi', picker("lsp_implementations"))
vim.keymap.set('n', 'gr', picker("lsp_references"))
vim.keymap.set('n', 'gy', picker("lsp_type_definitions"))

-- autocommands
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'CursorHoldI', 'FocusGained' }, {
  command = 'checktime',
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = matthewtodd.on_lsp_attach,
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

  fuzzy = { implementation = 'lua' },
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

require('mini.icons').setup {}

require('snacks').setup {
  input = {
    enabled = true,
  },
  notifier = {
    enabled = true,
  },
  picker = {
    enabled = true,
    ui_select = true,
  }
}

-- language servers
local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
})

vim.lsp.config('ruby_lsp', {
  on_attach = function(client, _)
    -- Prefer the symbols provided by Sorbet, since they seem faster and Telescope can't handle both.
    -- https://www.reddit.com/r/neovim/comments/zksmsa/telescope_lsp_dynamic_workspace_symbol_broken/
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.workspaceSymbolProvider = false
  end,
})

vim.lsp.config('sorbet', {
  -- Bridge's monorail has a Gemfile in a subdirectory that gets matched first
  -- by the default `root_pattern('Gemfile', '.git')`, which resulted in the
  -- sorbet ls being run down there and crashing because it couldn't find its
  -- config.
  root_markers = { '.git' },
})

require('typescript-tools').setup({
  capabilities = capabilities,
})

vim.lsp.enable({
  'clangd',
  'eslint',
  'lua_ls',
  'rust_analyzer',
  'ruby_lsp',
  'sorbet',
})

vim.lsp.commands['rubyLsp.runTestInTerminal'] = function(command)
  matthewtodd.register_codelens_run('rubyLsp.runTestInTerminal', command)
  vim.fn['test#strategy#neovim_sticky'](command.arguments[3])
  vim.cmd('wincmd =')
end

vim.diagnostic.config({
  jump = {
    float = true
  }
})

-- vim:et:sw=2:ts=2
