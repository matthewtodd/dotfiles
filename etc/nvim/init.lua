-- general settings
vim.opt.backupdir:remove({ '.' })
vim.opt.clipboard = 'unnamed'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'ag --vimgrep $*'
vim.opt.hlsearch = false
vim.opt.list = true
vim.opt.listchars = { tab = '→ ', trail = '·' , nbsp = '␣' }
vim.opt.number = true
vim.opt.wildmode = 'list:longest,full'

-- keyboard shortcuts
vim.g.mapleader = ','
vim.keymap.set('n', '<leader>a', ':grep!<space>')
vim.keymap.set('n', '<leader>b', ':FZFBuffers<cr>')
vim.keymap.set('n', '<leader>h', ':FZFHelptags<cr>')
vim.keymap.set('n', '<leader>t', ':FZFGFiles<cr>')

-- colorscheme
-- I wrote this solarized scheme to work regardless of background, but for some
-- reason, when the Terminal has a dark background, NeoVim falls back to the
-- default colorscheme. Setting background to light (or dark, for that matter)
-- somehow keeps NeoVim choosing solarized.
vim.opt.background = 'light'
vim.cmd.colorscheme('solarized')

-- autocommands
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'CursorHoldI', 'FocusGained' }, {
  pattern = '*',
  command = 'checktime',
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.go',
  callback = function(ev)
    vim.bo[ev.buf].listchars = 'tab:  ,trail:·,nbsp:␣'
    vim.bo[ev.buf].tabstop = 4
  end,
})

vim.api.nvim_create_autocmd({ 'QuickFixCmdPost' }, {
  pattern = '*',
  command = 'cwindow',
})

vim.api.nvim_create_autocmd({ 'VimResized' }, {
  pattern = '*',
  command = 'wincmd =',
})

-- plugin settings
vim.g.fzf_command_prefix = 'FZF'
