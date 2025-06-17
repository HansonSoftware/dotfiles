#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALACRITTY_DIR="$SCRIPT_DIR/alacritty"
NVIM_DIR="$SCRIPT_DIR/nvim"
TMUX_DIR="$SCRIPT_DIR/tmux"

CONFIG_DIR="$HOME/.config"
ALACRITTY_CONFIG="$CONFIG_DIR/alacritty/alacritty.yml"
NVIM_CONFIG="$CONFIG_DIR/nvim/colorscheme.vim"
TMUX_CONFIG="$HOME/.tmux.conf"

list_schemes() {
    echo "Available color schemes:"
    ls "$ALACRITTY_DIR" | sed 's/\..*$//' | sort | uniq
}

apply_scheme() {
    local scheme="$1"
    
    if [[ ! -f "$ALACRITTY_DIR/${scheme}.yml" ]] ||
       [[ ! -f "$NVIM_DIR/${scheme}.vim" ]] ||
       [[ ! -f "$TMUX_DIR/${scheme}.conf" ]]; then
        echo "Scheme '$scheme' not found in all directories."
        exit 1
    fi

    echo "Applying color scheme: $scheme"

    cp "$ALACRITTY_DIR/${scheme}.yml" "$ALACRITTY_CONFIG"
    cp "$NVIM_DIR/${scheme}.vim" "$NVIM_CONFIG"
    cp "$TMUX_DIR/${scheme}.conf" "$TMUX_CONFIG"

    echo "Reloading configurations..."

    if command -v tmux &> /dev/null && tmux info &> /dev/null; then
        tmux source-file "$TMUX_CONFIG"
    fi

    echo "Done. You may need to restart Alacritty or Neovim to see changes."
}

case "$1" in
    -l|--list)
        list_schemes
        ;;
    "")
        echo "Usage: $0 [-l|scheme-name]"
        ;;
    *)
        apply_scheme "$1"
        ;;
esac
