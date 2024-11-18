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
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')
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

local latest_command_type = ''
local latest_command = nil

local function rerun_latest_codelens()
  local latest_handler = vim.lsp.commands[latest_command_type]

  if latest_handler then
    latest_handler(latest_command)
  else
    run_nearest_codelens()
  end
end

local function run_nearest_codelens()
  local current_line = vim.fn.line('.') - 1
  local nearest_codelens_line = current_line
  local height = math.huge

  for _, codelens in pairs(vim.lsp.codelens.get()) do
    local start_line = codelens.command.arguments[4].start_line
    local end_line = codelens.command.arguments[4].end_line

    if start_line <= current_line and current_line <= end_line then
      local my_height = end_line - start_line
      if my_height < height then
        nearest_codelens_line = start_line + 1
        height = my_height
      end
    end
  end

  -- I would like to just pass a line number to vim.api.codelens.run, but it
  -- doesn't work that way, and I don't want to recreate it, so let's just move
  -- the cursor up.
  vim.api.nvim_win_set_cursor(0, {nearest_codelens_line, 0})
  vim.lsp.codelens.run()
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', telescope.lsp_definitions, opts)
    vim.keymap.set('n', 'gr', telescope.lsp_references, opts)
    vim.keymap.set('n', 'gi', telescope.lsp_implementations, opts)
    vim.keymap.set('n', '<leader>d', telescope.lsp_type_definitions, opts)
    vim.keymap.set('n', '<leader>s', telescope.lsp_document_symbols, opts)
    vim.keymap.set('n', '<leader>S', telescope.lsp_dynamic_workspace_symbols, opts)
    vim.keymap.set('n', '<leader>l', run_nearest_codelens, opts)
    vim.keymap.set('n', '<leader>L', rerun_latest_codelens, opts)
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

local test_failures_namespace = vim.api.nvim_create_namespace("org.matthewtodd.test-failures")

vim.diagnostic.config({
  float = {
    border = "single",
    format = function(diagnostic)
      return diagnostic.user_data and diagnostic.user_data.message or diagnostic.message
    end,
  }
})

vim.lsp.commands['rubyLsp.runTest'] = function(command)
  latest_command_type = 'rubyLsp.runTest'
  latest_command = command

  vim.diagnostic.reset(test_failures_namespace)

  vim.system(
    vim.split(command.arguments[3], " "),
    {
      env = { SPEC_OPTS = "--format=json" },
      text = true
    },
    function(completed)
      local lines = vim.split(completed.stdout, "\n")
      local results = vim.json.decode(lines[#lines])
      local diagnostics = {}

      for _, example in ipairs(results.examples) do
        if example.status == "failed" then
          local at = example.exception.backtrace[1]
          local file, line, _ = unpack(vim.split(at, ":"))

          if not diagnostics[file] then
            diagnostics[file] = {}
          end

          table.insert(diagnostics[file], {
            lnum = line - 1,
            col = 0,
            severity = vim.diagnostic.severity.ERROR,
            message = vim.split(example.exception.message, "\n")[1],
            source = example.full_description,
            namespace = test_failures_namespace,
            user_data = {
              message = example.exception.message
            }
          })
        end
      end

      vim.schedule(function()
        for file, file_diagnostics in pairs(diagnostics) do
          local bufnr = vim.fn.bufexists(file) == 1 and vim.fn.bufnr(file) or vim.fn.bufadd(file)
          vim.fn.bufload(file)
          vim.diagnostic.set(test_failures_namespace, bufnr, file_diagnostics, {})
        end

        if results.summary.failure_count > 0 then
          vim.api.nvim_echo({{results.summary_line, "MatthewToddTestsFailed"}}, false, {})
          telescope.diagnostics()
        else
          vim.api.nvim_echo({{results.summary_line, "MatthewToddTestsPassed"}}, false, {})
        end
      end)
    end
  )
end

vim.lsp.commands['rubyLsp.runTestInTerminal'] = function(command)
  latest_command_type = 'rubyLsp.runTestInTerminal'
  latest_command = command
  vim.fn['test#strategy#neovim_sticky'](command.arguments[3])
  vim.cmd('wincmd =')
end

-- TODO: use a different strategy here!
vim.lsp.commands['rubyLsp.debugTest'] = function(command)
  latest_command_type = 'rubyLsp.debugTest'
  latest_command = command
  vim.fn['test#strategy#neovim_sticky'](command.arguments[3])
  vim.cmd('wincmd =')
end

-- vim:et:sw=2:ts=2
