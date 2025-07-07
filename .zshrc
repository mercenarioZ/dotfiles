# zsh
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
#
# Alias
## File/Folder
alias l="ls --color=auto"
alias ll="ls -lah"
alias ..="cd .."

## Quick navigation
alias dot="cd ~/dotfiles/"

## Git
alias g="git"
