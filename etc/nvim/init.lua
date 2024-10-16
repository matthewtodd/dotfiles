-- general settings
vim.opt.backupdir:remove({ '.' })
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true
vim.opt.hlsearch = false
vim.opt.list = true
vim.opt.listchars = { tab = '→ ', trail = '·' , nbsp = '␣' }
vim.opt.number = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wildmode = 'list:longest,full'

-- keyboard shortcuts
local telescope = require('telescope.builtin')
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>a', telescope.live_grep)
vim.keymap.set('n', '<leader>b', telescope.buffers)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>h', telescope.help_tags)
vim.keymap.set('n', '<leader>q', telescope.diagnostics)
vim.keymap.set('n', '<leader>t', telescope.git_files)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

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

local last_test = ''

local function run_test_in_terminal(cmd)
  last_test = cmd
  vim.fn['test#strategy#neovim_sticky'](cmd)
  vim.cmd('wincmd =')
end

local function rerun_last_test()
  run_test_in_terminal(last_test)
end

local function run_test_or_offer_codelens_choice()
  local current_line = vim.fn.line('.') - 1
  local height = math.huge
  local command = nil

  for _, codelens in pairs(vim.lsp.codelens.get()) do
    if codelens.data.type == 'test_in_terminal' then
      local start_line = codelens.command.arguments[4].start_line
      local end_line = codelens.command.arguments[4].end_line

      if start_line <= current_line and current_line <= end_line then
        local my_height = end_line - start_line
        if my_height < height then
          height = my_height
          command = codelens.command.arguments[3]
        end
      end
    end
  end

  if command ~= nil then
    run_test_in_terminal(command)
  else
    vim.lsp.codelens.run()
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', telescope.lsp_definitions, opts)
    vim.keymap.set('n', 'gr', telescope.lsp_references, opts)
    vim.keymap.set('n', 'gi', telescope.lsp_implementations, opts)
    vim.keymap.set('n', '<leader>d', telescope.lsp_type_definitions, opts)
    vim.keymap.set('n', '<leader>S', telescope.lsp_document_symbols, opts)
    vim.keymap.set('n', '<leader>s', telescope.lsp_dynamic_workspace_symbols, opts)
    vim.keymap.set('n', '<leader>l', run_test_or_offer_codelens_choice, opts)
    vim.keymap.set('n', '<leader>L', rerun_last_test, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>c', vim.lsp.buf.code_action, opts)
    vim.keymap.set('v', '<leader>c', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if (client.server_capabilities.codeLensProvider) then
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        buffer = bufnr,
        callback = function(ev)
          vim.lsp.codelens.refresh()
        end
      })
    end

    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function(ev)
        vim.lsp.buf.format {
          async = false,
          filter = function(client)
            return client.name ~= 'sorbet'
          end
        }
      end
    })
  end
})

vim.api.nvim_create_autocmd({ 'QuickFixCmdPost' }, {
  command = 'cwindow',
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

require('telescope').setup {}
require('telescope').load_extension('fzf')

-- language servers
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = vim.tbl_deep_extend(
  'force',
  capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

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

vim.lsp.commands['rubyLsp.runTestInTerminal'] = function(command)
  run_test_in_terminal(command.arguments[3])
end

-- vim:et:sw=2:ts=2
