set -gx XDG_CONFIG_HOME "$HOME/.config"
set -g fish_greeting ""

fish_add_path --global --path \
    /opt/homebrew/bin \
    /home/linuxbrew/.linuxbrew/bin \
    "$HOME/.local/bin" \
    "$HOME/bin" \
    "$HOME/go/bin"

if status is-interactive
    if command -q mise
        mise activate fish | source
    end
end
