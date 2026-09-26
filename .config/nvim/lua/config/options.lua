local o = vim.opt

-- UI
o.number = true
o.cursorline = true
o.signcolumn = 'yes'
o.wrap = false
o.termguicolors = true
o.winborder = 'rounded'
o.list = true
o.listchars = { tab = '▸ ', trail = '·', extends = '»', precedes = '«' }

-- Indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- Search
o.hlsearch = true
o.ignorecase = true
o.smartcase = true
o.inccommand = 'split'

-- Splits
o.splitright = true
o.splitbelow = true

-- Files
o.undofile = true

-- Behaviour
o.mouse = 'a'
-- Keep yanks out of the system clipboard; use <leader>c to copy to it.
o.clipboard = ''
o.completeopt = { 'menuone', 'noselect', 'popup' }

-- Filetypes
vim.filetype.add({ extension = { svi = 'systemverilog' } })
