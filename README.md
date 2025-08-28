# Dotfiles

> Personal macOS development environment with LazyVim, Homebrew packages, and shell configuration

This repository contains my dotfiles managed as a bare Git repository for deployment across multiple machines. Includes a complete LazyVim Neovim setup, terminal configuration, and essential development tools.

## Features

- Complete LazyVim Neovim configuration with TypeScript, React, Java support
- Automated Homebrew package installation via Brewfile
- Enhanced Zsh with autosuggestions and syntax highlighting
- Modern CLI tools: fzf, ripgrep, bat, fd, yazi
- Development tools: Git, Docker, Terraform, Node.js, Python, Go
- Terminal setup with Ghostty and Nerd Fonts

## Quick Setup

### One-Line Install
```bash
curl -L https://raw.githubusercontent.com/Dillonzellis/dotfiles/master/scripts/setup-dotfiles.sh | bash
```

### Manual Installation

1. **Clone the repository**
   ```bash
   git clone --bare https://github.com/Dillonzellis/dotfiles.git $HOME/.dotfiles
   ```

2. **Create the config alias**
   ```bash
   alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
   ```

3. **Backup existing dotfiles** (if any conflicts)
   ```bash
   mkdir -p .config-backup
   config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
   ```

4. **Checkout dotfiles**
   ```bash
   config checkout
   config config --local status.showUntrackedFiles no
   ```

5. **Install packages**
   ```bash
   chmod +x ~/scripts/install-brew.sh
   ~/scripts/install-brew.sh
   ```

6. **Restart terminal**
   ```bash
   exec zsh
   ```


### Managing Dotfiles
```bash
# Check status
config status

# Add new files
config add .zshrc .gitconfig

# Commit changes
config commit -m "Update configuration"

# Push to remote
config push
```


## Adding New Packages
Edit the `Brewfile` and run:
```bash
brew bundle --file=~/Brewfile
```

## Troubleshooting

**Homebrew not in PATH (Apple Silicon)**
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Neovim plugins not loading**
```bash
nvim --headless "+Lazy! sync" +qa
```

## Requirements

- macOS (Monterey or later recommended)
- Git
- Terminal with Nerd Font support
