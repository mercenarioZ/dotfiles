# starship
eval "$(starship init zsh)"

# zsh
plugins=(z zsh-syntax-highlighting)

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Flutter
export PATH=$HOME/Documents/flutterSDK/flutter/bin:$PATH

# Alias
## File/Folder
alias l="ls --color=auto"
alias ll="ls -lah"
alias ..="cd .."

## Quick navigation
alias dot="cd ~/dotfiles/"

## Neovim
alias vim="nvim"

## Git
alias g="git"
