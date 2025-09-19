#!/usr/bin/env bash

# Directories to search
DIRS=(
  "$HOME/wks/"
  "$HOME/dotfiles"
)

# Fuzzy-pick from the list using `fd` + `sk`
selected=$(
  {
    # Get subdirectories from wks (with trailing slash, so it searches inside)
    fd . "$HOME/wks/" --type=dir --max-depth=1 --full-path --base-directory "$HOME"
    # Add dotfiles root directory itself (no trailing slash, so just the directory)
    echo "$HOME/dotfiles"
  } |
    sed "s|^$HOME/||" |
    sk --margin 10% --color="bw"
)

# If user hit Enter without selecting, switch back to last session
if [[ -z $selected ]]; then
  tmux switch-client -l
  exit 0
fi

# Add home path back and create session name
selected="$HOME/$selected"
selected_name=$(basename "$selected" | tr . _)

# Create session if it doesn't exist, then switch to it
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
