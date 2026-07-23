## Contents
- vim (Neovim) config
- git config
- prompt config via `starship`
- tmux config
- PowerShell config

## Symlink setup

`~/.config` will be a real directory so credentials and generated state remain
machine-local. Link only the shared application configs:

```sh
mkdir -p ~/.config

ln -s ~/dotfiles/.zshrc ~/.zshrc

ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.config/powershell ~/.config/powershell
ln -s ~/dotfiles/.config/starship ~/.config/starship
ln -s ~/dotfiles/.config/tmux ~/.config/tmux

mkdir -p ~/.config/hunk ~/.config/jj
ln -s ~/dotfiles/.config/hunk/config.toml ~/.config/hunk/config.toml
ln -s ~/dotfiles/.config/jj/config.toml ~/.config/jj/config.toml
```

Ghostty uses a platform-specific config; follow
`.config/ghostty/README.md`.

## Neovim setup

### Requirements

- Neovim >= **0.9.0** (needs to be built with **LuaJIT**)
- Git >= **2.19.0** (for partial clones support)
- a [Nerd Font](https://www.nerdfonts.com/)(v3.0 or greater) _(optional, but needed to display some icons)_.
- [lazygit](https://github.com/jesseduffield/lazygit) **_(optional)_**
- a **C** compiler for `nvim-treesitter`. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) **_(optional)_**
  - **live grep**: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - **find files**: [fd](https://github.com/sharkdp/fd)

## Shell setup (macOS & Linux)

- [Fish shell](https://fishshell.com/)
- [Fisher](https://github.com/jorgebucaran/fisher) - Plugin manager
- [Tide](https://github.com/IlanCosman/tide) - Shell theme
- [Nerd fonts](https://github.com/ryanoasis/nerd-fonts) - I use BlexMono
- [z for fish](https://github.com/jethrokuan/z) - Directory jumping
- [Eza](https://github.com/eza-community/eza) - `ls` replacement
- [ghq](https://github.com/x-motemen/ghq) - Local Git repository organizer
- [fzf](https://github.com/PatrickF1/fzf.fish) - Interactive filtering

## PowerShell setup (Windows)

- [Scoop](https://scoop.sh/) - A command-line installer
- [Git for Windows](https://gitforwindows.org/)
- [Oh My Posh](https://ohmyposh.dev/) - Prompt theme engine
- [Terminal Icons](https://github.com/devblackops/Terminal-Icons) - Folder and file icons
- [PSReadLine](https://docs.microsoft.com/en-us/powershell/module/psreadline/) - Cmdlets for customizing the editing environment, used for autocompletion
- [z](https://www.powershellgallery.com/packages/z) - Directory jumper
- [PSFzf](https://github.com/kelleyma49/PSFzf) - Fuzzy finder

Credit: This README was adapted from [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public).
