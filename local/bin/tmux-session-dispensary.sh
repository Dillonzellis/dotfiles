#!/usr/bin/env bash

# Directories to search
DIRS=(
  "$HOME/wks/"
  "$HOME/dotfiles"
  "$HOME/orgfiles"
)

# Fuzzy-pick from the list using `fd` + `sk`
selected=$(
  {
    for dir in "${DIRS[@]}"; do
      if [[ "$dir" == "$HOME/wks/" ]]; then
        # List subdirectories of wks
        fd . "$dir" --type=dir --max-depth=1 --full-path --base-directory "$HOME"
      else
        # Just include the directory itself
        echo "$dir"
      fi
    done
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
