# .dotfiles

Minimal macOS dotfiles: zsh, tmux, WezTerm, Neovim, Karabiner-Elements.
No shell framework; Neovim uses the built-in `vim.pack`, tmux uses TPM.

Managed as a **bare git repo**: the git dir is `~/.dotfiles`, the work tree is `$HOME`,
and every file is tracked at its real path. `.gitignore` ignores everything and
opts files in explicitly. (Method: <https://www.atlassian.com/git/tutorials/dotfiles>)

## What's tracked

| Path | What |
| --- | --- |
| `~/.zshrc` | Shell: history, completion, tiny `vcs_info` prompt |
| `~/.config/zsh/aliases.zsh` | Aliases, including `dotfiles` |
| `~/.tmux.conf` | tmux: `C-a` prefix, vi copy mode, single-line status, resurrect + continuum |
| `~/.config/wezterm/wezterm.lua` | WezTerm (left Option = Alt, right Option types characters) |
| `~/.config/nvim/` | Neovim 0.12+: `vim.pack`, native LSP + completion, treesitter, telescope, gruvbox |
| `~/.config/karabiner/karabiner.json` | Karabiner-Elements settings (+ `assets/` rules) |
| `~/.github/` | This README and the bootstrap script |

Machine-specific settings and secrets go in `~/.zshrc.local` (not tracked).

## Install on a new Mac

```sh
brew install git neovim tmux ripgrep tree-sitter-cli lua-language-server
brew install --cask wezterm karabiner-elements

curl -fsSL https://raw.githubusercontent.com/tiago-sRib/.dotfiles/main/.github/bootstrap.sh | sh
exec zsh
```

The bootstrap script clones the bare repo, checks the files out into `$HOME`
(moving any it would overwrite to `~/.dotfiles-backup/`), hides untracked files
from `dotfiles status`, sets up `origin` tracking so `dotfiles pull/push` work, and
clones TPM into `~/.tmux/plugins/tpm`.

<details><summary>Manual steps (what the script does)</summary>

```sh
git clone --bare https://github.com/tiago-sRib/.dotfiles.git ~/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfiles checkout            # move away any conflicting files and rerun if it complains
dotfiles config status.showUntrackedFiles no
dotfiles config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dotfiles fetch origin && dotfiles branch --set-upstream-to=origin/main main
```
</details>

Then:

- **tmux**: start it and press `C-a I` to install the plugins.
- **Neovim**: the first launch asks to install the plugins, then builds the treesitter
  parsers (others are installed the first time you open a file of that type).
- **Karabiner**: if you already have a config, track it with
  `dotfiles add ~/.config/karabiner && dotfiles commit -m "Add karabiner" && dotfiles push`.

## Daily use

```sh
dotfiles status
dotfiles add ~/.config/wezterm/wezterm.lua
dotfiles commit -m "wezterm: bigger font"
dotfiles push
```

### Tracking a new file

Because everything is ignored by default, allow it in `~/.gitignore` first, then add it:

```gitignore
!/.config/ghostty/
```

```sh
dotfiles add ~/.gitignore ~/.config/ghostty
```

## Neovim

- Plugins: `nvim-treesitter` (main branch), `telescope.nvim` (+ `plenary.nvim`),
  `gruvbox.nvim` (hard contrast), `log-highlight.nvim`. Update with
  `:lua vim.pack.update()`; versions are pinned in `nvim-pack-lock.json`.
- Leader is `<Space>`:

  | Keys | Action | Keys | Action |
  | --- | --- | --- | --- |
  | `p` | find files | `s` | save |
  | `f` | live grep | `w` | close buffer |
  | `g` | live grep with dirs / exclude globs | `q` | quit |
  | `b` | switch buffer | `e` | file explorer (netrw) |
  | `o` | `:e ` a path | `n` | new buffer |
  | `c` | copy line/selection to clipboard | `y` | copy file's absolute path |
  | `a` | select all | `h` | clear search highlight |
  | `z` | toggle wrap | | |

- `Shift-h` / `Shift-l` go to the previous / next buffer.
- `<` / `>` in visual mode indent and keep the selection.

- Yanks stay out of the system clipboard (`clipboard=''`); use `<Space>c`.
- LSP: built-in keymaps (`K`, `grn`, `gra`, `grr`, `gri`, `gO`), plus `gd` and `<Space>lf` format.
  Add a server: `brew install` it, create `~/.config/nvim/lsp/<name>.lua`, add the name to
  `vim.lsp.enable({...})` in `lua/config/lsp.lua`.
