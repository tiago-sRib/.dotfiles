-- Neovim config. Needs Neovim 0.12+ (built-in vim.pack).

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.plugins')
require('config.lsp')
