#!/bin/bash

git clone --bare git@github.com:Dillonzellis/dotfiles.git $HOME/.dotfiles

function config {
  /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

mkdir -p .config-backup

config checkout

if [ $? = 0 ]; then
  echo "Checked out config."
else
  echo "Backing up pre-existing dot files."
  # Get list of conflicting files and back them up properly
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | while read file; do
    # Create parent directory in backup location
    mkdir -p ".config-backup/$(dirname "$file")"
    # Move the file
    mv "$file" ".config-backup/$file"
    echo "Backed up: $file"
  done
fi

config checkout
config config status.showUntrackedFiles no
