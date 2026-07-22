# Shared interactive Zsh configuration for macOS and Linux.

# Homebrew
if [[ -d "/opt/homebrew/bin" ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
elif [[ -d "/home/linuxbrew/.linuxbrew/bin" ]]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

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

# starship
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# Kept for compatibility with the existing shell setup.
plugins=(z)

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Flutter SDK used by this Mac. Other machines can override it in
# ~/.zshrc.local without committing machine-specific paths.
if [[ -d "$HOME/Documents/flutterSDK/flutter/bin" ]]; then
  export PATH="$HOME/Documents/flutterSDK/flutter/bin:$PATH"
fi

# Java on macOS. Linux uses its system JAVA_HOME or ~/.zshrc.local.
if [[ "$OSTYPE" == darwin* ]] && [[ -x /usr/libexec/java_home ]]; then
  export JAVA_HOME="$(/usr/libexec/java_home -v 21)"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

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

# zsh-autosuggestions installed through Homebrew
if (( $+commands[brew] )); then
  ZSH_AUTOSUGGESTIONS="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -r "$ZSH_AUTOSUGGESTIONS" ]] && source "$ZSH_AUTOSUGGESTIONS"
  unset ZSH_AUTOSUGGESTIONS
fi

# bun
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Custom binaries
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# Optional per-machine overrides. Keep this file outside the repository.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Isolated Codex CLI profile
[[ -r "$HOME/.zshrc-codex" ]] && source "$HOME/.zshrc-codex"
