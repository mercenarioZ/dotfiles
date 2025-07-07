# zsh
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"


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
