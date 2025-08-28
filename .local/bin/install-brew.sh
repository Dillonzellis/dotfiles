#!/bin/bash

# install-brew.sh - Homebrew and Brewfile installer
# Part of dotfiles setup system

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

print_status "🍺 Starting Homebrew and package installation..."

# ==============================================================================
# CHECK MACOS
# ==============================================================================
if [[ "$OSTYPE" != "darwin"* ]]; then
  print_error "This script is designed for macOS only"
  exit 1
fi

# ==============================================================================
# INSTALL HOMEBREW
# ==============================================================================
print_status "Checking for Homebrew..."
if ! command -v brew &>/dev/null; then
  print_status "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon Macs
  if [[ $(uname -m) == 'arm64' ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  print_success "Homebrew installed successfully"
else
  print_success "Homebrew already installed"
  print_status "Updating Homebrew..."
  brew update
fi

# ==============================================================================
# VALIDATE BREWFILE
# ==============================================================================
print_status "Looking for Brewfile..."

BREWFILE_PATH="$HOME/Brewfile"
if [ ! -f "$BREWFILE_PATH" ]; then
  print_error "Brewfile not found at $BREWFILE_PATH"
  print_status "Make sure your dotfiles are checked out first"
  exit 1
fi

print_success "Found Brewfile at $BREWFILE_PATH"

# ==============================================================================
# INSTALL FROM BREWFILE
# ==============================================================================
print_status "Installing packages from Brewfile..."
print_warning "This may take several minutes..."

# Show what would be installed (dry run)
print_status "Packages to be installed:"
brew bundle list --file="$BREWFILE_PATH" | head -10
echo "... and more"

# Ask for confirmation
read -p "Continue with installation? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  print_warning "Installation cancelled by user"
  exit 0
fi

# Install packages
cd "$HOME"
if brew bundle --file="$BREWFILE_PATH"; then
  print_success "All packages installed successfully from Brewfile"
else
  print_warning "Some packages may have failed to install"
  print_status "You can run 'brew bundle --file=~/Brewfile' later to retry"
fi

# ==============================================================================
# POST-INSTALL SETUP
# ==============================================================================
print_status "Running post-install setup..."

# Set up fzf key bindings if fzf was installed
if command -v fzf &>/dev/null; then
  print_status "Setting up fzf key bindings..."
  if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
    $(brew --prefix)/opt/fzf/install --all --no-bash --no-fish
    print_success "fzf key bindings installed"
  fi
fi

# Make sure zsh plugins are properly sourced
if [ -f "$HOME/.zshrc" ]; then
  print_status "Checking zsh plugin configuration..."

  # Check for zsh-autosuggestions
  if ! grep -q "zsh-autosuggestions" "$HOME/.zshrc" 2>/dev/null; then
    print_warning "Consider adding this to your .zshrc:"
    echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi

  # Check for zsh-syntax-highlighting
  if ! grep -q "zsh-syntax-highlighting" "$HOME/.zshrc" 2>/dev/null; then
    print_warning "Consider adding this to your .zshrc:"
    echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi
fi

# ==============================================================================
# CLEANUP
# ==============================================================================
print_status "Cleaning up..."
brew cleanup

# ==============================================================================
# SUMMARY
# ==============================================================================
print_success "Homebrew setup complete!"
echo
print_status "Installed packages summary:"
brew list --formula | wc -l | xargs echo "CLI tools:"
brew list --cask | wc -l | xargs echo "Applications:"

echo
print_status "Next steps:"
echo "  1. Restart your terminal or source your shell config"
echo "  2. Check that GUI applications are in /Applications"
echo "  3. Configure your applications as needed"

# Check for potential issues
print_status "Health check:"
brew doctor --quiet && print_success "Homebrew configuration looks good" || print_warning "Run 'brew doctor' to check for issues"

print_status "Installation log saved to: $(brew --repository)/install.log"
