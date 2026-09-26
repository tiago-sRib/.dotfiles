-- brew install lua-language-server
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.stylua.toml', 'stylua.toml', '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      -- Know about the Neovim API when editing this config.
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = { enable = false },
    },
  },
}
