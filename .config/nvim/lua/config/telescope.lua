-- Telescope setup plus a live grep that can be scoped to directories and
-- exclude patterns. Uses ripgrep (brew install ripgrep).
local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup({})

local M = {}

-- Prompt for directories (space-separated, empty = cwd) and patterns to
-- exclude (space-separated globs, e.g. `*.log build/**`), then live grep.
function M.live_grep_filtered()
  vim.ui.input({ prompt = 'Dirs (empty = cwd): ', completion = 'dir' }, function(dirs)
    if dirs == nil then return end
    vim.ui.input({ prompt = 'Exclude globs: ' }, function(excludes)
      if excludes == nil then return end
      local opts = {}
      local search_dirs = vim.split(vim.trim(dirs), '%s+', { trimempty = true })
      if #search_dirs > 0 then
        opts.search_dirs = vim.tbl_map(vim.fs.normalize, search_dirs)
      end
      local globs = vim.split(vim.trim(excludes), '%s+', { trimempty = true })
      if #globs > 0 then
        opts.glob_pattern = vim.tbl_map(function(g) return '!' .. g end, globs)
      end
      builtin.live_grep(opts)
    end)
  end)
end

return M
