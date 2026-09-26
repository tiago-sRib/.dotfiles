-- Native LSP. Server configs live in ~/.config/nvim/lsp/<name>.lua.
-- To add a server: install it (brew), drop a config in lsp/, add its name below.
--
-- Built-in keymaps (:h lsp-defaults): K hover, grn rename, gra code action,
-- grr references, gri implementation, gO document symbols, <C-s> signature help.

vim.lsp.enable({ 'lua_ls' })

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { source = true },
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('config.lsp', { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local buf = args.buf

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
    end

    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = desc })
    end
    map('gd', vim.lsp.buf.definition, 'Go to definition')
    map('<leader>lf', function() vim.lsp.buf.format({ async = true }) end, 'Format buffer')
  end,
})
