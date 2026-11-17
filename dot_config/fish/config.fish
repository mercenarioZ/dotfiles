set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx BUN_INSTALL "$HOME/.bun"
set -g fish_greeting ""

fish_add_path --global --path \
    /opt/homebrew/bin \
    /home/linuxbrew/.linuxbrew/bin \
    "$HOME/.local/bin" \
    "$HOME/bin" \
    "$HOME/go/bin" \
    "$BUN_INSTALL/bin"

if status is-interactive
    if command -q mise
        mise activate fish | source
    end

    if command -q eza
        alias ls 'eza --icons'
        alias l 'eza -l --icons'
        alias la 'eza -la --icons'
        alias ll 'eza -l --icons'
    else
        alias l 'ls -l'
        alias la 'ls -la'
        alias ll 'ls -lah'
    end

    alias vim nvim
    alias ports 'lsof -iTCP -sTCP:LISTEN -n -P'
    abbr -a g git
end

# machine-specific env and secrets, never committed
for f in config-local.fish secrets.fish
    test -r "$__fish_config_dir/$f"; and source "$__fish_config_dir/$f"
end
