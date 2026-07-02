#!/bin/bash
# install.sh - Copy configs from repo to their destinations in the user's home directory.

set -euo pipefail

# Ensure target directories exist
mkdir -p "$HOME/.config/ghostty"
mkdir -p "$HOME/.config/fish"

# Copy configurations
cp bash/.bashrc "$HOME/.bashrc"
cp bash/.bash_profile "$HOME/.bash_profile"
cp bash/.profile "$HOME/.profile"
cp vim/.vimrc "$HOME/.vimrc"
cp ghostty/config "$HOME/.config/ghostty/config"
cp fish/config.fish "$HOME/.config/fish/config.fish"

echo "Configurations successfully copied to home directories!"
