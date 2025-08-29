#!/bin/bash

# setup-dotfiles.sh - Complete dotfiles setup with Homebrew integration
# Usage: curl -L https://raw.githubusercontent.com/Dillonzellis/dotfiles/master/.local/bin/setup-dotfiles.sh | bash

set -e # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

echo "Starting complete dotfiles setup..."
echo "======================================"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
  print_error "This script is designed for macOS only"
  exit 1
fi

# ==============================================================================
# STEP 1: CLONE DOTFILES REPOSITORY
# ==============================================================================
print_status "Step 1: Setting up dotfiles repository"

if [ -d "$HOME/.dotfiles" ]; then
  print_warning "Dotfiles repository already exists, pulling latest changes..."
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" pull
else
  print_status "Cloning dotfiles repository..."
  git clone --bare git@github.com:Dillonzellis/dotfiles.git $HOME/.dotfiles
fi

# Create the config function
function config {
  /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# ==============================================================================
# STEP 2: BACKUP EXISTING FILES
# ==============================================================================
print_status "Step 2: Backing up existing dotfiles"

backup_dir="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

print_status "Checking out dotfiles..."
if ! config checkout 2>/dev/null; then
  print_warning "Found existing dotfiles, backing them up to $backup_dir"

  # Get list of conflicting files and back them up properly
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | while read file; do
    # Create parent directory in backup location
    mkdir -p "$backup_dir/$(dirname "$file")"
    # Move the file
    if [ -f "$file" ]; then
      mv "$file" "$backup_dir/$file"
      print_status "Backed up: $file"
    fi
  done

  # Try checkout again
  config checkout
fi

# Configure the repository
config config --local status.showUntrackedFiles no
print_success "Dotfiles checked out successfully"

# ==============================================================================
# STEP 3: INSTALL HOMEBREW & PACKAGES
# ==============================================================================
print_status "Step 3: Installing Homebrew and packages"

# Check if install-brew.sh exists in the dotfiles
if [ -f "$HOME/.local/bin/install-brew.sh" ]; then
  print_status "Found install-brew.sh, running package installation..."
  chmod +x "$HOME/.local/bin/install-brew.sh"
  bash "$HOME/.local/bin/install-brew.sh"
elif [ -f "$HOME/Brewfile" ]; then
  print_status "Found Brewfile, installing packages directly..."

  # Quick Homebrew check and install
  if ! command -v brew &>/dev/null; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add to PATH for Apple Silicon
    if [[ $(uname -m) == 'arm64' ]]; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi

  # Install from Brewfile
  cd "$HOME"
  print_status "Installing packages from Brewfile..."
  brew bundle --file=Brewfile
  print_success "Packages installed from Brewfile"
else
  print_warning "No Brewfile or install-brew.sh found, skipping package installation"
fi

# ==============================================================================
# STEP 4: SHELL CONFIGURATION
# ==============================================================================
print_status "Step 4: Setting up shell configuration"

# Set zsh as default shell if it isn't already
if [ "$SHELL" != "$(which zsh)" ]; then
  print_status "Setting zsh as default shell..."
  chsh -s "$(which zsh)"
  print_success "Default shell changed to zsh"
fi

# Source shell configuration
if [ -f "$HOME/.zshrc" ]; then
  print_status "Zsh configuration found"
  # Note: Can't source in script context, user needs to restart shell
fi

# ==============================================================================
# STEP 5: APPLICATION-SPECIFIC SETUP
# ==============================================================================
print_status "Step 5: Application-specific setup"

# Set up fzf if installed
if command -v fzf &>/dev/null && [ -f "$(brew --prefix)/opt/fzf/install" ]; then
  print_status "Setting up fzf key bindings..."
  $(brew --prefix)/opt/fzf/install --all --no-bash --no-fish
fi

# ==============================================================================
# STEP 6: SET UP GIT CONFIG
# ==============================================================================

setup_git_config() {

  print_status "Step 6: Setting up git config from gitconfig template"
  print_status "Setting up Git configuration..."

  if [ -f "$HOME/.gitconfig.template" ] && [ ! -f "$HOME/.gitconfig" ]; then
    print_status "Git config template found. Setting up personal config..."

    read -p "Enter your Git username: " git_username
    read -p "Enter your Git email (or press Enter for GitHub noreply): " git_email

    # Default to GitHub noreply format if no email provided
    if [ -z "$git_email" ]; then
      print_status "Getting GitHub user ID for noreply email..."
      # You could fetch this from GitHub API if needed
      git_email="${git_username}@users.noreply.github.com"
    fi

    # Create actual .gitconfig from template
    sed "s/YOUR_USERNAME/$git_username/g; s/YOUR_EMAIL@users.noreply.github.com/$git_email/g" \
      "$HOME/.gitconfig.template" >"$HOME/.gitconfig"

    print_success "Git configuration created with:"
    print_success "  Name: $git_username"
    print_success "  Email: $git_email"
  else
    print_status "Git configuration already exists or template not found"
  fi
}

# ==============================================================================
# STEP 6: MACOS SYSTEM PREFERENCES (OPTIONAL)
# ==============================================================================
if [ -f "$HOME/.macos" ]; then
  read -p "Run macOS system preferences script? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Running macOS system preferences..."
    bash "$HOME/.macos"
    print_success "macOS preferences applied"
  fi
fi

# ==============================================================================
# COMPLETION SUMMARY
# ==============================================================================
print_success "Dotfiles setup complete!"
echo
print_status "What was installed:"
echo "   Dotfiles cloned and checked out"
echo "   Homebrew packages installed"
echo "   Shell configured"
echo "   Application settings applied"

if [ -d "$backup_dir" ] && [ "$(ls -A $backup_dir 2>/dev/null)" ]; then
  print_warning "Original dotfiles backed up to: $backup_dir"
fi

echo
print_status "Next steps:"
echo "  1. Restart your terminal or run: exec zsh"
echo "  2. Test your setup: config status"
echo "  3. Customize as needed"

echo
print_status "Useful commands:"
echo "  config status    # Check dotfiles git status"
echo "  config add .     # Add changes"
echo "  config commit    # Commit changes"
echo "  config push      # Push to GitHub"

echo
print_status "Enjoy your new development environment"
