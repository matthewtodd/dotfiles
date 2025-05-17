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
vim.opt.listchars = { tab = '→ ', trail = '·' , nbsp = '␣' }
vim.opt.number = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = false
vim.opt.wildmode = 'list:longest,full'

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
local cmp = require('cmp')

cmp.setup {
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-y>'] = cmp.mapping.confirm { select = true },
  }),
  sources = {
    { name = 'nvim_lsp' },
  },
}

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
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = vim.tbl_deep_extend(
  'force',
  capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

require('lspconfig').eslint.setup({
  capabilities = capabilities,
})

require('lspconfig').ruby_lsp.setup({
  cmd = { "bundle", "exec", "ruby-lsp" },
  capabilities = capabilities,
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

vim.diagnostic.config({
  virtual_text = { current_line = true }
})

-- vim:et:sw=2:ts=2
