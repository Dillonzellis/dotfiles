# Dotfiles

> My macOS development setup with LazyVim, tmux, and all the tools I actually use

This is my personal dotfiles repo that I use across different machines. It's got my complete Neovim setup with LazyVim, terminal config, and pretty much everything I need to get coding quickly on a new Mac.

## What's included

- LazyVim Neovim config (TypeScript, React, Java, and more)
- Homebrew packages via Brewfile - only the stuff I actually use
- Zsh with autosuggestions and syntax highlighting
- Useful CLI tools: fzf, ripgrep, yazi, etc.
- tmux configuration with vim-style navigation
- Ghostty terminal setup with Nerd Fonts
- Custom script for ghostty opacity/blur control (check out `.local/bin/gt`)

## How this works

This uses a bare Git repository setup, which means your home directory becomes the working tree. The `config` command is just an alias for git that points to the bare repo. Only files you explicitly add with `config add` get tracked - everything else in your home directory is ignored by default.

## Quick install

Just run this and you're good to go:

```bash
curl -L https://raw.githubusercontent.com/Dillonzellis/dotfiles/master/.local/bin/setup-dotfiles.sh | bash
```

The script will:

- Clone the dotfiles
- Install Homebrew and all packages
- Set up your Git config (it'll ask for your username/email)
- Configure your shell

### Wallpaper options

By default, wallpapers are excluded from the setup to keep downloads fast. You can include them with:

```bash
# Get prompted with wallpaper size and file count
curl -L https://raw.githubusercontent.com/Dillonzellis/dotfiles/master/.local/bin/setup-dotfiles.sh | bash -s -- --wallpapers

# Force download without prompting (if you know you want them)
curl -L https://raw.githubusercontent.com/Dillonzellis/dotfiles/master/.local/bin/setup-dotfiles.sh | bash -s -- --force-wallpapers
```

If you skip wallpapers initially, you can always add them later:

```bash
config checkout -- .local/share/wallpapers/
```

## Manual install

1. **Clone as bare repo**

   ```bash
   git clone --bare https://github.com/Dillonzellis/dotfiles.git $HOME/.dotfiles
   ```

2. **Set up the config alias**

   ```bash
   alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
   ```

3. **Backup any existing files**

   ```bash
   mkdir -p .config-backup
   config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
   ```

4. **Check out the files**

   ```bash
   config checkout
   config config --local status.showUntrackedFiles no
   ```

5. **Install packages**

   ```bash
   chmod +x ~/.local/bin/install-brew.sh
   ~/.local/bin/install-brew.sh
   ```

6. **Set up Git config**
   The setup script handles this, but if you're doing it manually:

   ```bash
   cp .gitconfig.template .gitconfig
   # Edit .gitconfig with your info
   ```

7. **Restart your terminal**

   ```bash
   exec zsh
   ```

## Managing your dotfiles

```bash
# Check what's changed
config status

# Add new files (be specific - don't use 'config add .')
config add .zshrc .tmux.conf

# Commit and push
config commit -m "Update shell config"
config push
```

**Important:** The `config` command has safety checks to prevent you from accidentally adding your entire home directory. Always add specific files.

## Adding new packages

Just edit the `Brewfile` and run:

```bash
brew bundle --file=~/Brewfile
```

## Troubleshooting

**Homebrew not found (Apple Silicon Macs)**

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Neovim being weird**

```bash
nvim --headless "+Lazy! sync" +qa
```

**tmux session script not working**
Make sure the script is executable:

```bash
chmod +x ~/.local/bin/tmux-session-dispensary.sh
```

## Notes

This setup assumes you're using Ghostty as your terminal and have a Nerd Font installed. If you use a different terminal, you might need to tweak some configs. The Brewfile installs fonts automatically, so you should be covered.

Feel free to fork this and make it your own and let me know you find it useful or have suggestions.
