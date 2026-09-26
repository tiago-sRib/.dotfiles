-- WezTerm config (macOS)
-- Lives at: ~/.config/wezterm/wezterm.lua
-- WezTerm reloads it automatically when you save.
-- Problems? Press Ctrl+Shift+L (or Cmd+Shift+L) to see errors with line numbers.

local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

----------------------------------------------------------------------
-- 1. Option key
--    Left Option  -> Alt/Meta, so Alt keybindings work in tmux, Neovim
--                    and zsh (Alt+B / Alt+F to jump words).
--    Right Option -> normal macOS behaviour, so it still types
--                    characters like [ ] { } @ € on your layout.
----------------------------------------------------------------------
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

----------------------------------------------------------------------
-- 2. Right-click pastes from the clipboard
--    Cmd+V also pastes (WezTerm default, nothing to add).
----------------------------------------------------------------------
config.mouse_bindings = {
  -- when nothing is capturing the mouse
  { event = { Down = { streak = 1, button = 'Right' } }, mods = 'NONE',
    action = act.PasteFrom 'Clipboard' },
  -- inside tmux (mouse on) too; replaces tmux's right-click menu
  { event = { Down = { streak = 1, button = 'Right' } }, mods = 'NONE',
    mouse_reporting = true, action = act.PasteFrom 'Clipboard' },
}

----------------------------------------------------------------------
-- 3. Font  (EDIT font_name later)
--    Put your Nerd Font's name between the quotes, e.g.
--    'JetBrainsMono Nerd Font'. Leave '' to keep WezTerm's default.
--    List the names WezTerm can see:  wezterm ls-fonts --list-system
----------------------------------------------------------------------
local font_name = ''

if font_name ~= '' then
  config.font = wezterm.font(font_name)
end
config.font_size = 14

-- No ligatures: '->', '=>', '!=' stay as the characters you typed.
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

----------------------------------------------------------------------
-- 4. Colors: Gruvbox dark (hard), same as Neovim
--    The tab bar uses matching colors; the active tab blends into the
--    terminal background.
----------------------------------------------------------------------
config.color_scheme = 'GruvboxDarkHard'

local bg, bg1, bg2 = '#1d2021', '#282828', '#3c3836'
local fg, fg_dim = '#ebdbb2', '#a89984'
config.colors = {
  tab_bar = {
    background = bg1,
    inactive_tab_edge = bg2,
    active_tab = { bg_color = bg, fg_color = fg },
    inactive_tab = { bg_color = bg1, fg_color = fg_dim },
    inactive_tab_hover = { bg_color = bg2, fg_color = fg },
    new_tab = { bg_color = bg1, fg_color = fg_dim },
    new_tab_hover = { bg_color = bg2, fg_color = fg },
  },
}

----------------------------------------------------------------------
-- 5. Window: no separate macOS title bar
--    The traffic-light buttons move into the tab bar, so there's one
--    thin bar instead of two. Drag the window by the empty part of it.
--    For no buttons at all, use: config.window_decorations = 'RESIZE'
----------------------------------------------------------------------
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.integrated_title_button_style = 'MacOsNative'

if wezterm.target_triple:find('darwin') then
  -- macOS draws the native traffic lights itself; the compact tab bar is
  -- one text line tall, so they get clipped. The fancy bar is tall enough.
  config.use_fancy_tab_bar = true
  config.window_frame = {
    font_size = 13,
    active_titlebar_bg = bg1,
    inactive_titlebar_bg = bg1,
  }
else
  -- Compact tab bar that uses the terminal font
  config.use_fancy_tab_bar = false
end
config.tab_max_width = 32

-- Less empty space around the text
config.window_padding = { left = 4, right = 4, top = 2, bottom = 2 }

-- No "are you sure?" when closing: the window (red button, Cmd+Q) or a tab (Cmd+W).
config.window_close_confirmation = 'NeverPrompt'
config.keys = {
  { key = 'w', mods = 'SUPER', action = act.CloseCurrentTab { confirm = false } },
}


config.term = 'xterm-256color'

-- Must stay the very last line. Anything after it is ignored.
return config
