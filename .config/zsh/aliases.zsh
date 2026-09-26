# Aliases, sourced from ~/.zshrc.

# Dotfiles: bare repo in ~/.dotfiles, work tree is $HOME.
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Editor
alias v='nvim'

# Listing (BSD ls on macOS)
alias ls='ls -G'
alias ll='ls -lhG'
alias la='ls -lAhG'
alias l='ls -lAhG'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias p='pwd -L'
alias .='pwd'

# Files
findd() { find . -type d -name "$1"; }   # find a directory by name below .
findf() { find . -type f -name "$1"; }   # find a file by name below .
mkbak() { cp -- "$1" "$1.bak"; }         # copy to <file>.bak
# Replace a symlink with a real copy of the file it points to
ln2file() { cp -- "$1" "$1.tmp" && unlink -- "$1" && mv -- "$1.tmp" "$1"; }

# Git
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate -20'

# tmux: attach to a session, creating it if needed (default name: main)
t() { tmux new-session -A -s "${1:-main}"; }
alias tl='tmux ls'

# Misc
alias grep='grep --color=auto'
alias reload='exec zsh'
