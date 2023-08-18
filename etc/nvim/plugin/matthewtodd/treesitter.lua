require('nvim-treesitter.configs').setup({
  -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  ensure_installed = "all",

  -- https://github.com/nvim-treesitter/nvim-treesitter#available-modules
  highlight = {
    enable = true,
  },
})
