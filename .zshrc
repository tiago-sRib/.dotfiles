# ~/.zshrc: no framework, no plugins.

# --- Environment -------------------------------------------------------------
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

typeset -U path
path=("$HOME/.local/bin" $path)

export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-R -F -i'

# --- History -----------------------------------------------------------------
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space hist_reduce_blanks extended_history

# --- Options -----------------------------------------------------------------
setopt autocd interactive_comments no_beep

# Emacs keys on the command line (Ctrl-A/E, Alt-B/F with left Option).
bindkey -e
# Up/Down search history for what is already typed.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
# Edit the current command in $EDITOR with Ctrl-X Ctrl-E.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# --- Completion --------------------------------------------------------------
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ''

# --- Prompt ------------------------------------------------------------------
# 14:05 dir (branch*) ❯   (grey time, current folder only, red ❯ after a failed command)
# Named colors, so they follow the terminal's color scheme.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' %F{magenta}(%b%F{yellow}%u%c%F{magenta})%f'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}(%b|%F{red}%a%F{yellow}%u%c%F{magenta})%f'
autoload -Uz add-zsh-hook
add-zsh-hook precmd vcs_info
setopt prompt_subst
PROMPT='%F{8}%D{%H:%M}%f %B%F{cyan}%1~%f%b${vcs_info_msg_0_} %(?.%F{green}.%F{red})❯%f '

# --- Aliases & local overrides -----------------------------------------------
[[ -r $HOME/.config/zsh/aliases.zsh ]] && source "$HOME/.config/zsh/aliases.zsh"
# Machine-specific settings and secrets (not tracked).
[[ -r $HOME/.zshrc.local ]] && source "$HOME/.zshrc.local"
