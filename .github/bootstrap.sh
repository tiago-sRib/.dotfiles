#!/bin/sh
# Set up these dotfiles on a new machine (bare repo in ~/.dotfiles, work tree = $HOME).
#
#   curl -fsSL https://raw.githubusercontent.com/tiago-sRib/.dotfiles/main/.github/bootstrap.sh | sh
#
# Files in $HOME that would be overwritten are moved to ~/.dotfiles-backup first.
set -eu

repo=${DOTFILES_REPO:-https://github.com/tiago-sRib/.dotfiles.git}
git_dir=$HOME/.dotfiles
backup_dir=$HOME/.dotfiles-backup

dotfiles() {
  git --git-dir="$git_dir" --work-tree="$HOME" "$@"
}

if [ -e "$git_dir" ]; then
  echo "$git_dir already exists, aborting." >&2
  exit 1
fi

git clone --bare "$repo" "$git_dir"

if ! dotfiles checkout 2>/dev/null; then
  echo "Backing up existing files to $backup_dir"
  # Tracked files that already exist in $HOME
  dotfiles ls-tree -r --name-only HEAD | while IFS= read -r f; do
    if [ -e "$HOME/$f" ] || [ -L "$HOME/$f" ]; then
      mkdir -p "$backup_dir/$(dirname "$f")"
      mv "$HOME/$f" "$backup_dir/$f"
    fi
  done
  dotfiles checkout
fi

dotfiles config status.showUntrackedFiles no

# A bare clone has no remote-tracking branches; add them so plain
# `dotfiles pull` / `dotfiles push` work.
branch=$(dotfiles symbolic-ref --short HEAD)
dotfiles config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dotfiles fetch --quiet origin
dotfiles branch --quiet --set-upstream-to="origin/$branch" "$branch"

# tmux plugin manager (install the plugins with prefix + I inside tmux)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone --quiet https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "Done. Open a new shell and use 'dotfiles status'."
