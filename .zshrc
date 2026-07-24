# Shared interactive Zsh configuration for macOS and Linux.

# Homebrew
if [[ -d "/opt/homebrew/bin" ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
elif [[ -d "/home/linuxbrew/.linuxbrew/bin" ]]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

# Persistent command history for search and autosuggestions.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# pyenv
if [[ -d "$HOME/.pyenv/shims" ]]; then
  export PATH="$HOME/.pyenv/shims:$PATH"
fi
if (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# fzf
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
  bindkey '^X^F' fzf-file-widget
fi

# Smarter directory navigation.
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# starship
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

[[ $- == *i* ]] && fastfetch

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Device-specific environment such as Flutter and Java paths.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Local credentials. This file is never committed.
[[ -r "$HOME/.zsh-secrets" ]] && source "$HOME/.zsh-secrets"

### -----------------------------
### LS (COLOR + ICONS via eza)
### -----------------------------
if (( $+commands[eza] )); then
  alias ls='eza --icons'
  alias l='eza -l --icons'
  alias la='eza -la --icons'
  alias ll='eza -l --icons'
else
  if [[ "$OSTYPE" == darwin* ]]; then
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad
    alias ls='ls -G'
  else
    alias ls='ls --color=auto'
  fi
  alias l='ls -l'
  alias la='ls -la'
  alias ll='ls -lah'
fi

# Navigation
alias dot='cd "$HOME/dotfiles"'
alias ..='cd ..'

# Neovim
alias vim='nvim'

# Git
alias g='git'

# Common local binaries
export PATH="$HOME/.local/bin:$PATH"

# Utilities
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'

# Fish-like suggestions from shell history.
if [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif (( $+commands[brew] )); then
  autosuggestions_file="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -r "$autosuggestions_file" ]] && source "$autosuggestions_file"
  unset autosuggestions_file
fi

# bun
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Custom binaries
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# Isolated Codex CLI profile
[[ -r "$HOME/.zshrc-codex" ]] && source "$HOME/.zshrc-codex"

# Keep syntax highlighting last so it can wrap all ZLE widgets.
if [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif (( $+commands[brew] )); then
  syntax_highlighting_file="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -r "$syntax_highlighting_file" ]] && source "$syntax_highlighting_file"
  unset syntax_highlighting_file
fi
