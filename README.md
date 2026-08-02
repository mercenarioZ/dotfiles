# Dotfiles

Personal configuration shared across macOS, Linux, and Windows. Platform-specific
files are called out below; do not link every directory on every operating system.

## Platform support

| Component | Path | macOS | Linux | Windows | Notes |
| --- | --- | :---: | :---: | :---: | --- |
| Neovim | `.config/nvim` | Yes | Yes | Yes | LazyVim-based; Windows uses the mappings in `for_windows/`. |
| Git | `.gitconfig` | Yes | Yes | Yes | Shared aliases and color settings. |
| Zsh | `.zshrc` | Yes | Yes | No | Detects Homebrew/Linuxbrew and loads optional tools only when available. |
| Starship | `.config/starship` | Yes | Yes | Not wired | Used by the shared Zsh config. |
| Fastfetch | `.config/fastfetch` | Yes | Yes | Not wired | Shared Unix setup in this repository. |
| tmux | `.config/tmux` | Yes | Yes | No | Automatically loads `macos.conf` or `linux.conf`. Linux clipboard support assumes Wayland and `wl-copy`. |
| Ghostty | `.config/ghostty` | Yes | Yes | No | Uses a different config file on each platform. |
| Hyprland + Quickshell | `.config/hypr`, `.config/quickshell` | No | Yes | No | **Linux/Wayland only.** |
| Hunk + Jujutsu | `.config/hunk`, `.config/jj` | Yes | Yes | Not wired | Shared CLI configuration; generated state stays local. |
| PowerShell | `.config/powershell` | No | No | Yes | **Windows-only setup in this repository.** |

`Not wired` means the application may support that operating system, but this
repository does not currently provide installation or symlink instructions for it.

## Safe symlink setup (macOS and Linux)

Keep `~/.config` as a real directory so credentials, plugins, caches, and generated
state remain machine-local.

> [!IMPORTANT]
> The destination must not already exist. Running `ln -s SOURCE EXISTING_DIRECTORY`
> creates a nested link such as `fastfetch/fastfetch` or `tmux/tmux` instead of
> replacing the directory.

Set `DOTFILES` to the actual clone location, then use this guarded helper:

```sh
DOTFILES="$HOME/code/dotfiles" # change this if the repository is cloned elsewhere

link_config() {
  source_path="$1"
  target_path="$2"

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    printf 'Not linking: %s already exists\n' "$target_path" >&2
    return 1
  fi

  ln -s "$source_path" "$target_path"
}

mkdir -p "$HOME/.config"

link_config "$DOTFILES/.zshrc" "$HOME/.zshrc"
link_config "$DOTFILES/.config/nvim" "$HOME/.config/nvim"
link_config "$DOTFILES/.config/fastfetch" "$HOME/.config/fastfetch"
link_config "$DOTFILES/.config/starship" "$HOME/.config/starship"
link_config "$DOTFILES/.config/tmux" "$HOME/.config/tmux"

mkdir -p "$HOME/.config/hunk" "$HOME/.config/jj"
link_config "$DOTFILES/.config/hunk/config.toml" "$HOME/.config/hunk/config.toml"
link_config "$DOTFILES/.config/jj/config.toml" "$HOME/.config/jj/config.toml"
```

The shared Zsh config optionally loads `~/.zshrc.local` for device-specific paths
(for example Java or Flutter) and `~/.zsh-secrets` for credentials. Both files are
ignored by Git.

### Ghostty (macOS or Linux)

Ghostty needs a platform-specific file linked as `~/.config/ghostty/config`:

```sh
mkdir -p "$HOME/.config/ghostty"

# macOS only
link_config "$DOTFILES/.config/ghostty/config" "$HOME/.config/ghostty/config"

# Linux only: use this instead of the macOS line
link_config "$DOTFILES/.config/ghostty/linux.conf" "$HOME/.config/ghostty/config"
```

The macOS file contains `macos-option-as-alt`; the Linux file contains GTK,
quick-terminal, and Linux desktop integration settings.

### Linux/Wayland desktop only

Hyprland and the `quiet` Quickshell desktop are not used on macOS or Windows:

```sh
link_config "$DOTFILES/.config/hypr" "$HOME/.config/hypr"
link_config "$DOTFILES/.config/quickshell" "$HOME/.config/quickshell"
```

### Windows only

Windows symlink mappings are listed in `for_windows/symlinks-windows.json`. They
cover Neovim, Git, and PowerShell. Windows Developer Mode or an elevated shell may
be required to create symbolic links.

## Quiet desktop (Linux/Wayland only)

The desktop requires Hyprland 0.56+ and uses Hyprland's native Lua configuration
from `.config/hypr/hyprland.lua`, together with the named Quickshell config at
`.config/quickshell/quiet/`. Hyprlock, Hypridle, Hyprpaper, and Hyprsunset remain
separate programs with their own `.conf` files in `.config/hypr/`.

Core shortcuts:

- `Super + D` or `Super + Space`: application launcher
- `Super + O`: control and notification drawer
- `Super + /`: shortcut manual
- `Super + Escape`: session menu
- `Super + Return`: terminal
- `Super + E`: file manager
- `Super + 1..0`: switch workspaces 1 through 10
- `Super + Shift + 1..0`: move the active window to a workspace
- `Ctrl + Space`: toggle English/Vietnamese input (Unikey VNI)

Runtime helpers: `quickshell`, `hyprpaper`, `hypridle`, `hyprlock`, `hyprsunset`,
`brightnessctl`, `playerctl`, `fcitx5`, `fcitx5-unikey`, `grim`, `slurp`, `swappy`,
`wl-copy`, and `xdg-open`.

The `EN`/`VI` menu-bar control mirrors Fcitx state: left-click it to toggle the
input method, or right-click it to open Fcitx configuration.

Open the control drawer with `Super + O`, then choose **Wallpaper** to browse
images from `~/Pictures/wallpapers`. The selection is stored locally at
`~/.local/state/quiet/wallpaper`, so changing it does not modify the repository.
The volume section also includes a native PipeWire output selector for connected
speakers, headphones, HDMI, and Bluetooth audio devices.

## Neovim setup (macOS, Linux, and Windows)

Requirements:

- Neovim >= **0.11.2**, built with **LuaJIT**
- Git >= **2.19.0** for partial clone support
- A C compiler for `nvim-treesitter`
- A [Nerd Font](https://www.nerdfonts.com/) v3+ for icons (optional)
- [lazygit](https://github.com/jesseduffield/lazygit) (optional)
- [ripgrep](https://github.com/BurntSushi/ripgrep) for live grep (optional)
- [fd](https://github.com/sharkdp/fd) for file finding (optional)

Language servers and tools managed by Mason may have their own runtime
requirements. For example, JDT LS requires a local Java runtime even when Mason
has successfully downloaded the server.

## Zsh setup (macOS and Linux)

Zsh is the shell configured by this repository. Most integrations are optional
and activate only when their command or startup file is available:

- [Starship](https://starship.rs/) for the prompt
- [fzf](https://github.com/junegunn/fzf) for interactive filtering
- [zoxide](https://github.com/ajeetdsouza/zoxide) for directory navigation
- [eza](https://github.com/eza-community/eza) as the preferred `ls` replacement
- `zsh-autosuggestions` and `zsh-syntax-highlighting`
- `pyenv`, `nvm`, Bun, and Homebrew/Linuxbrew when installed

## PowerShell setup (Windows only)

- [Scoop](https://scoop.sh/) - command-line installer
- [Git for Windows](https://gitforwindows.org/)
- [Oh My Posh](https://ohmyposh.dev/) - prompt theme engine
- [Terminal Icons](https://github.com/devblackops/Terminal-Icons) - file icons
- [PSReadLine](https://learn.microsoft.com/powershell/module/psreadline/) - command-line editing and completion
- [z](https://www.powershellgallery.com/packages/z) - directory jumper
- [PSFzf](https://github.com/kelleyma49/PSFzf) - fuzzy finder

Credit: This README was adapted from
[craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public).
