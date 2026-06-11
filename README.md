# .dotfiles

My personal configuration files managed with GNU Stow.

## Prerequisites

Depending on which configurations you wish to apply, you may need the following:

- **Management**: GNU Stow (Required)
- **Shell**: Zsh
- **Editor**: Neovim
- **Window Manager**: i3wm
- **Multiplexer**: tmux
- **Terminal**: Alacritty or Ghostty

## Installation

1. Clone the repository:
   ```bash
   git clone git@github.com:pdjansse/.dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the setup script to install prerequisites and symlink configurations:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

## Project Structure

- `zsh/`: Shell configuration
- `nvim/`: Neovim configuration
- `i3/`: i3 window manager configuration
- `tmux/`: Terminal multiplexer configuration
- `alacritty/`: Alacritty terminal configuration
- `ghostty/`: Ghostty terminal configuration
