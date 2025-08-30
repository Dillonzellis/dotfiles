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

# Check for command line arguments
INCLUDE_WALLPAPERS=false
FORCE_WALLPAPERS=false

while [[ $# -gt 0 ]]; do
  case $1 in
  --wallpapers)
    INCLUDE_WALLPAPERS=true
    shift
    ;;
  --force-wallpapers)
    FORCE_WALLPAPERS=true
    INCLUDE_WALLPAPERS=true
    shift
    ;;
  --help)
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --wallpapers        Check wallpaper size and prompt for inclusion"
    echo "  --force-wallpapers  Force wallpapers download without prompting"
    echo "  --help              Show this help message"
    exit 0
    ;;
  *)
    print_warning "Unknown option: $1"
    shift
    ;;
  esac
done

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
# WALLPAPER HANDLING SETUP
# ==============================================================================
setup_sparse_checkout() {
  print_status "Setting up sparse checkout configuration..."

  # Enable sparse checkout
  config config core.sparseCheckout true

  # Create sparse-checkout file
  sparse_checkout_file="$HOME/.dotfiles/info/sparse-checkout"
  mkdir -p "$(dirname "$sparse_checkout_file")"

  # Base patterns (always included)
  cat >"$sparse_checkout_file" <<'EOF'
# Always include these patterns
/*
!.local/share/wallpapers/
EOF

  if [ "$INCLUDE_WALLPAPERS" = true ]; then
    echo ".local/share/wallpapers/" >>"$sparse_checkout_file"
    print_status "Wallpapers will be included in checkout"
  else
    print_status "Wallpapers will be excluded from checkout"
  fi
}

# ==============================================================================
# WALLPAPER SIZE CHECK AND PROMPT
# ==============================================================================
check_and_prompt_wallpapers() {
  if [ "$INCLUDE_WALLPAPERS" = true ] && [ "$FORCE_WALLPAPERS" = false ]; then
    print_status "Checking wallpaper directory size..."

    # Use GitHub API to check directory size (rough estimate)
    wallpaper_info=$(curl -s "https://api.github.com/repos/Dillonzellis/dotfiles/contents/.local/share/wallpapers" 2>/dev/null || echo "[]")

    if command -v jq >/dev/null 2>&1; then
      total_size=$(echo "$wallpaper_info" | jq '[.[] | .size] | add' 2>/dev/null || echo "0")
      file_count=$(echo "$wallpaper_info" | jq 'length' 2>/dev/null || echo "0")
    else
      # Fallback without jq - rough estimate
      total_size=$(echo "$wallpaper_info" | grep -o '"size":[0-9]*' | cut -d: -f2 | awk '{sum += $1} END {print sum}')
      file_count=$(echo "$wallpaper_info" | grep -c '"name"' || echo "0")
    fi

    if [ "$total_size" -gt 0 ]; then
      size_mb=$((total_size / 1024 / 1024))
      echo
      print_status "📊 Wallpaper Directory Information:"
      echo "   Files: $file_count wallpapers"
      echo "   Size:  ~${size_mb}MB"
      echo

      # Always prompt when --wallpapers is used (unless --force-wallpapers)
      echo -n "Download wallpapers? (y/N): "
      read -r response
      if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_status "Skipping wallpapers. You can add them later with: config checkout -- .local/share/wallpapers/"
        INCLUDE_WALLPAPERS=false
      else
        print_success "Wallpapers will be downloaded"
      fi
    else
      print_warning "Could not determine wallpaper directory size. Proceeding with download."
    fi
  elif [ "$FORCE_WALLPAPERS" = true ]; then
    print_status "Force downloading wallpapers (--force-wallpapers used)"
  fi
}

# ==============================================================================
# STEP 2: BACKUP EXISTING FILES
# ==============================================================================
print_status "Step 2: Setting up file checkout strategy"

backup_dir="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

# Check wallpaper size and prompt user if --wallpapers was used
check_and_prompt_wallpapers

# Set up sparse checkout after user decision
setup_sparse_checkout

print_status "Checking out dotfiles..."
if ! config checkout 2>/dev/null; then
  print_warning "Found existing dotfiles, backing them up to $backup_dir"

  # Get list of conflicting files and back them up properly
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | while read file; do
    # Skip wallpaper conflicts if we're not including them
    if [ "$INCLUDE_WALLPAPERS" = false ] && [[ "$file" == .local/share/wallpapers/* ]]; then
      continue
    fi

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

# Apply sparse checkout settings
config read-tree -m -u HEAD

# Configure the repository
config config --local status.showUntrackedFiles no
print_success "Dotfiles checked out successfully"

if [ "$INCLUDE_WALLPAPERS" = true ]; then
  print_success "Wallpapers included in checkout"

  # Copy wallpapers to ~/Pictures/wallpapers
  if [ -d "$HOME/.local/share/wallpapers" ]; then
    print_status "Copying wallpapers to ~/Pictures/wallpapers..."

    # If ~/Pictures/wallpapers exists, back it up first
    if [ -d "$HOME/Pictures/wallpapers" ]; then
      print_warning "~/Pictures/wallpapers already exists, backing up to ~/Pictures/wallpapers_backup"
      mv "$HOME/Pictures/wallpapers" "$HOME/Pictures/wallpapers_backup"
    fi

    # Create Pictures directory if it doesn't exist
    mkdir -p "$HOME/Pictures"

    # Copy wallpapers
    cp -r "$HOME/.local/share/wallpapers" "$HOME/Pictures/"
    print_success "Wallpapers copied to ~/Pictures/wallpapers"
  else
    print_warning "Wallpapers directory not found in dotfiles"
  fi
else
  print_status "Wallpapers excluded. Add later with: config checkout -- .local/share/wallpapers/"
fi

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
      git_email="${git_username}@users.noreply.github.com"
    fi

    # Create actual .gitconfig from template
    sed "s/yourname/$git_username/g; s/youremail@example.com/$git_email/g" \
      "$HOME/.gitconfig.template" >"$HOME/.gitconfig"

    print_success "Git configuration created with:"
    print_success "  Name: $git_username"
    print_success "  Email: $git_email"
  else
    print_status "Git configuration already exists or template not found"
  fi
}

setup_git_config

# ==============================================================================
# STEP 7: MACOS SYSTEM PREFERENCES (OPTIONAL)
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
echo "   ✓ Dotfiles cloned and checked out"
echo "   ✓ Homebrew packages installed"
echo "   ✓ Shell configured"
echo "   ✓ Application settings applied"

if [ "$INCLUDE_WALLPAPERS" = true ]; then
  echo "   ✓ Wallpapers included and copied to ~/Pictures/wallpapers"
else
  echo "   - Wallpapers excluded (add with: config checkout -- .local/share/wallpapers/)"
fi

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
echo "  config status                              # Check dotfiles git status"
echo "  config add .zshrc .tmux.conf               # Add specific changes"
echo "  config commit -m 'Update config'          # Commit changes"
echo "  config push                                # Push to GitHub"

# Only show wallpaper command if wallpapers were not included
if [ "$INCLUDE_WALLPAPERS" = false ]; then
  echo "  config checkout -- .local/share/wallpapers/  # Add wallpapers later"
fi

echo
print_status "Enjoy your new development environment! 🚀"
