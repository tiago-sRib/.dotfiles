-- Plugins via the built-in package manager (:h vim.pack).
-- Update: :lua vim.pack.update()   Versions are pinned in nvim-pack-lock.json.

-- Rebuild treesitter parsers whenever nvim-treesitter is updated.
-- Defined before vim.pack.add() so it is in place for any install/update.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/fei6409/log-highlight.nvim',
})

-- Colorscheme --------------------------------------------------------------
require('gruvbox').setup({ contrast = 'hard' })
vim.o.background = 'dark'
vim.cmd.colorscheme('gruvbox')

-- Treesitter ---------------------------------------------------------------
-- Needs the tree-sitter CLI to build parsers (brew install tree-sitter-cli).
local ts = require('nvim-treesitter')
ts.install({ 'markdown', 'markdown_inline', 'lua', 'vim', 'vimdoc' })

local function ts_start(buf)
  if pcall(vim.treesitter.start, buf) then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

-- Highlight/indent with treesitter, installing a missing parser on first use.
local available, installing = nil, {}
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf = args.buf
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then return end
    if vim.treesitter.language.add(lang) then return ts_start(buf) end

    available = available or ts.get_available()
    if installing[lang] or not vim.list_contains(available, lang) then return end
    installing[lang] = true
    ts.install(lang):await(function(err)
      installing[lang] = nil
      if err then return end
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then ts_start(buf) end
      end)
    end)
  end,
})

-- Log files ----------------------------------------------------------------
require('log-highlight').setup({
  extension = 'log',
  filename = { 'syslog' },
  pattern = {
    -- Use `%` to escape special characters and match them literally.
    '%/var%/log%/.*',
    'console%-ramoops.*',
    'log.*%.txt',
    'logcat.*',
  },
})

-- Picker -------------------------------------------------------------------
require('config.telescope')
