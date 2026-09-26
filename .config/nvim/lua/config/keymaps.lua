local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Buffers and files
map('n', '<leader>w', '<cmd>bdelete<CR>', 'Close buffer')
map('n', '<leader>s', '<cmd>write<CR>', 'Save file')
map('n', '<leader>q', '<cmd>quit<CR>', 'Quit')
map('n', '<leader>e', '<cmd>Explore<CR>', 'File explorer')
map('n', '<leader>n', '<cmd>enew<CR>', 'New buffer')
vim.keymap.set('n', '<leader>o', ':e ', { desc = 'Open file by path' })
map('n', '<S-l>', '<cmd>bnext<CR>', 'Next buffer')
map('n', '<S-h>', '<cmd>bprevious<CR>', 'Previous buffer')

-- Telescope
map('n', '<leader>p', function() require('telescope.builtin').find_files() end, 'Find files')
map('n', '<leader>f', function() require('telescope.builtin').live_grep() end, 'Live grep in cwd')
map('n', '<leader>g', function() require('config.telescope').live_grep_filtered() end,
  'Live grep with dir/exclude filters')
map('n', '<leader>b', function() require('telescope.builtin').buffers() end, 'Switch buffer')

-- Editing
map('n', '<leader>h', '<cmd>nohlsearch<CR>', 'Clear search highlight')
map('n', '<leader>a', 'gg0vG$', 'Select all')
map('n', '<leader>z', '<cmd>set wrap!<CR>', 'Toggle wrap')

-- Keep selection when indenting
map('v', '<', '<gv', 'Indent left')
map('v', '>', '>gv', 'Indent right')

-- System clipboard
map('n', '<leader>c', '"+yy', 'Copy line to clipboard')
map('v', '<leader>c', '"+y', 'Copy selection to clipboard')
map('n', '<leader>y', function()
  vim.fn.setreg('+', vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p'))
end, 'Copy absolute file path')
