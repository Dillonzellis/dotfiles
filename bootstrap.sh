#!/usr/bin/env bash

# Bootstrap Dotfiles Installation Script
# Usage: curl -sSL https://raw.githubusercontent.com/Dilonzellis/dotfiles/master/bootstrap.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

GITHUB_USER="Dillonzellis"
REPO_NAME="dotfiles"

# Derived variables
REPO_URL="https://github.com/Dillonzellis/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

print_info() {
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

print_banner() {
  echo
  echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║           Dotfiles Setup             ║${NC}"
  echo -e "${GREEN}║                                      ║${NC}"
  echo -e "${GREEN}║  Repository: ${GITHUB_USER}/${REPO_NAME}${NC}"
  echo -e "${GREEN}║                                      ║${NC}"
  echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
  echo
}

# Check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if not present (macOS/Linux)
install_homebrew() {
  if ! command_exists brew; then
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      else
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    fi
    print_success "Homebrew installed!"
  else
    print_success "Homebrew already installed"
  fi
}

# Install Git if not present
install_git() {
  if ! command_exists git; then
    print_info "Installing Git..."
    if command_exists brew; then
      brew install git
    elif command_exists apt-get; then
      sudo apt-get update && sudo apt-get install -y git
    elif command_exists yum; then
      sudo yum install -y git
    elif command_exists pacman; then
      sudo pacman -S --noconfirm git
    else
      print_error "Could not install Git. Please install it manually and run this script again."
      exit 1
    fi
    print_success "Git installed!"
  else
    print_success "Git already installed"
  fi
}

# Clone or update dotfiles repository
setup_dotfiles_repo() {
  if [ -d "$DOTFILES_DIR" ]; then
    print_info "Dotfiles directory exists. Updating..."
    cd "$DOTFILES_DIR"
    git stash push -m "Auto-stash before bootstrap update $(date)"
    git pull origin "$BRANCH"
    print_success "Dotfiles repository updated!"
  else
    print_info "Cloning dotfiles repository..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
    print_success "Dotfiles repository cloned to $DOTFILES_DIR"
  fi
}

# Function to create symlink with backup
create_symlink() {
  local source="$1"
  local target="$2"
  local description="$3"

  # Create target directory if it doesn't exist
  local target_dir
  target_dir="$(dirname "$target")"
  if [ ! -d "$target_dir" ]; then
    print_info "Creating directory: $target_dir"
    mkdir -p "$target_dir"
  fi

  # If target exists and is not a symlink, back it up
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
    print_warning "Backing up existing $description to $backup"
    mv "$target" "$backup"
  fi

  # Remove existing symlink if it exists
  if [ -L "$target" ]; then
    rm "$target"
  fi

  # Create the symlink
  ln -s "$source" "$target"
  print_success "Linked $description"
}

# Function to make scripts executable
make_executable() {
  local script="$1"
  if [ -f "$script" ]; then
    chmod +x "$script"
  fi
}

# Install dotfiles
install_dotfiles() {
  print_info "Installing dotfiles..."
  cd "$DOTFILES_DIR"

  # Homebrew Brewfile
  if [ -f "Brewfile" ]; then
    create_symlink "$DOTFILES_DIR/Brewfile" "$HOME/Brewfile" "Homebrew Brewfile"
  fi

  # Zsh configuration
  if [ -f "zshrc" ]; then
    create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc" "Zsh configuration"
  fi

  # Tmux configuration
  if [ -f "tmux.conf" ]; then
    create_symlink "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf" "Tmux configuration"
  fi

  # Git configuration
  if [ -f "gitconfig" ]; then
    create_symlink "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig" "Git configuration"
  fi

  # Neovim configuration
  if [ -d "config/nvim" ]; then
    create_symlink "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim" "Neovim configuration"
  fi

  # Ghostty configuration
  if [ -d "config/ghostty" ]; then
    create_symlink "$DOTFILES_DIR/config/ghostty" "$HOME/.config/ghostty" "Ghostty configuration"
  fi

  # Local bin scripts
  if [ -d "local/bin" ]; then
    create_symlink "$DOTFILES_DIR/local/bin" "$HOME/.local/bin" "Local bin directory"

    # Make scripts executable
    for script in "$DOTFILES_DIR/local/bin"/*; do
      if [ -f "$script" ]; then
        make_executable "$script"
      fi
    done
  fi

  print_success "Dotfiles installation complete!"
}

# Install Homebrew packages
install_brew_packages() {
  if [ -f "$HOME/Brewfile" ] && command_exists brew; then
    print_info "Installing Homebrew packages..."
    brew bundle install --global
    print_success "Homebrew packages installed!"
  fi
}

# Set default shell to zsh
set_default_shell() {
  if command_exists zsh && [ "$SHELL" != "$(which zsh)" ]; then
    print_info "Setting default shell to zsh..."
    chsh -s "$(which zsh)"
    print_success "Default shell set to zsh (restart terminal to take effect)"
  fi
}

# Main installation flow
main() {
  print_banner

  print_info "Starting dotfiles installation..."
  print_info "Repository: $REPO_URL"
  print_info "Installation directory: $DOTFILES_DIR"
  echo

  # Install prerequisites
  install_homebrew
  install_git

  # Setup dotfiles
  setup_dotfiles_repo
  install_dotfiles
  install_brew_packages
  set_default_shell

  echo
  print_success "🎉 Dotfiles installation completed successfully!"
  echo
  print_info "Next steps:"
  echo "  1. Restart your terminal or run: exec zsh"
  echo "  2. Open Neovim to install plugins: nvim"
  echo "  3. Configure any remaining personal settings"
  echo
  print_info "Your dotfiles are located at: $DOTFILES_DIR"
  print_info "To update dotfiles in the future, run: cd $DOTFILES_DIR && git pull"
  echo
}

# Check if running in CI or non-interactive environment
if [ -t 0 ]; then
  # Interactive mode - ask for confirmation
  echo "This script will:"
  echo "  • Install Homebrew (if not present)"
  echo "  • Install Git (if not present)"
  echo "  • Clone your dotfiles repository to ~/.dotfiles"
  echo "  • Create symlinks for all configuration files"
  echo "  • Install Homebrew packages from Brewfile"
  echo "  • Set zsh as your default shell"
  echo
  echo "Repository: $REPO_URL"
  echo
  read -p "Continue? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    main
  else
    print_info "Installation cancelled."
    exit 0
  fi
else
  # Non-interactive mode (piped from curl)
  main
fi
