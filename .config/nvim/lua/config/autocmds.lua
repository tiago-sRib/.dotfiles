local group = vim.api.nvim_create_augroup('config', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  desc = 'Highlight yanked text',
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  desc = 'Restore cursor to last position',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
