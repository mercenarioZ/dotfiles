# Ghostty platform configs

- `config` is the existing macOS configuration.
- `linux.conf` is the Linux configuration.

Link the appropriate file on each device:

```sh
# Linux
ln -s ~/dotfiles/.config/ghostty/linux.conf ~/.config/ghostty/config

# macOS
ln -s ~/dotfiles/.config/ghostty/config ~/.config/ghostty/config
```
