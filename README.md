--bare repo for dotfiles

alias to handle dotfiles
- alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
- use this like git cli

config status
config push

Configure the repo to hide untracked files
config config --local status.showUntrackedFiles no

Clone and setup
git clone --bare https://github.com/Dillonzellis/dotfiles.git $HOME/.dotfiles

Create the alias
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Try to checkout (this might fail if files already exist)
config checkout

Handle conflicts if checkout fails
 If checkout fails due to existing files, you'll see something like:
 error: The following untracked working tree files would be overwritten by checkout:
     .zshrc
     .config/nvim/init.lua

# Back up existing files
mkdir -p .config-backup
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}

# Now checkout should work
config checkout

# Finish setup
# Hide untracked files
config config --local status.showUntrackedFiles no



# Quick Setup
Run this one-liner on any new machine:

```bash
curl -L https://raw.githubusercontent.com/Dillonzellis/dotfiles/master/setup-dotfiles.sh | bash
