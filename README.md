## MercenarioZ's dotfiles

Personal configuration for macOS, Linux, and Windows. Use at your own risk.

@craftzdog inspired me a lot, thank u so much!

## Contents

Managed with [chezmoi](https://www.chezmoi.io/).

- Neovim config
- Git config
- Zsh, Starship, and Fastfetch config (macOS, Linux)
- tmux, Ghostty, LazyGit, Hunk, and Jujutsu config (macOS, Linux)
- Rex and mise config
- Hyprland and Quickshell desktop (Linux/Wayland)
- PowerShell config (Windows)

## Setup

### chezmoi

Point chezmoi at this clone in `~/.config/chezmoi/chezmoi.toml`:

```toml
sourceDir = "/path/to/dotfiles"
```

Enter the Git name and email once (`--prompt` asks again), preview, and apply:

```sh
chezmoi init
chezmoi diff
chezmoi apply
```

Non-config files at the repository root must be listed in `.chezmoiignore`. On a
machine set up with the old symlinks, remove them before the first `chezmoi apply`.

Zsh sets `XDG_CONFIG_HOME=~/.config`, so macOS tools such as LazyGit read from
`~/.config` too. It optionally loads `~/.zshrc.local` (device-specific paths) and
`~/.zsh-secrets` (credentials); both stay out of the repository.

### Windows

```powershell
winget install twpayne.chezmoi
[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", "$HOME\.config", "User")
chezmoi apply
```

Then load the profile from `$PROFILE`:

```powershell
. "$HOME\.config\powershell\user_profile.ps1"
```

## Neovim setup

- Neovim >= **0.12** (plugins are managed with the built-in `vim.pack`)
- Git
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) 0.26.1+ and a **C**
  compiler for `nvim-treesitter`
- A [Nerd Font](https://www.nerdfonts.com/) v3+
- [ripgrep](https://github.com/BurntSushi/ripgrep) for live grep,
  [fd](https://github.com/sharkdp/fd) for finding files (optional)
- [gh](https://cli.github.com/) for Octo.nvim (`gh auth login`, then `:checkhealth octo`)
- Node.js for the Vue, Astro, and TypeScript language servers

Per-server LSP settings live in `dot_config/nvim/after/lsp/`.

## Shell setup (macOS, Linux)

Integrations activate only when installed:

- [Starship](https://starship.rs/) - prompt
- [fzf](https://github.com/junegunn/fzf) - interactive filtering
- [zoxide](https://github.com/ajeetdsouza/zoxide) - directory jumping
- [eza](https://github.com/eza-community/eza) - `ls` replacement
- `zsh-autosuggestions` and `zsh-syntax-highlighting`
- `pyenv`, `nvm`, Bun, and Homebrew/Linuxbrew

## Quiet desktop (Linux/Wayland)

- Hyprland 0.56+ with Lua config in `dot_config/hypr/hyprland.lua`
- Quickshell config in `dot_config/quickshell/quiet/`
- Helpers: `hyprpaper`, `hypridle`, `hyprlock`, `hyprsunset`, `brightnessctl`,
  `playerctl`, `fcitx5`, `fcitx5-unikey`, `grim`, `slurp`, `swappy`, `wl-copy`,
  `xdg-open`

`Super + O` opens the control drawer (wallpaper, audio output). The `EN`/`VI`
indicator toggles Fcitx on left-click and opens its settings on right-click.

## PowerShell setup (Windows)

- [Scoop](https://scoop.sh/) - command-line installer
- [Git for Windows](https://gitforwindows.org/)
- [Oh My Posh](https://ohmyposh.dev/) - prompt theme engine
- [Terminal Icons](https://github.com/devblackops/Terminal-Icons) - file icons
- [PSReadLine](https://learn.microsoft.com/powershell/module/psreadline/) - editing and completion
- [z](https://www.powershellgallery.com/packages/z) - directory jumper
- [PSFzf](https://github.com/kelleyma49/PSFzf) - fuzzy finder

Credit: This README was adapted from
[craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public).
