#!/usr/bin/env bash

# Directories to search
DIRS=(
  "$HOME/dev/"
  "$HOME/.local/"
  "$HOME/.config"
)

# If a directory was passed as an argument, use it
if [[ $# -eq 1 ]]; then
  selected=$1
else
  # Otherwise fuzzy-pick from the list using `fd` + `sk`
  selected=$(fd . "${DIRS[@]}" \
    --type=dir --max-depth=1 --full-path --base-directory "$HOME" |
    sed "s|^$HOME/||" |
    sk --margin 10% --color="bw")

  # Fallback: if user hit Enter without selecting anything
  if [[ -z $selected ]]; then
    # If we’re inside tmux, go back to the last session
    if [[ -n $TMUX ]]; then
      last_session=$(tmux display-message -p '#S')
      tmux switch-client -t "$last_session"
    fi
    exit 0
  fi

  # Add home path back
  selected="$HOME/$selected"
fi

# Session name = folder name (dots replaced with underscores)
selected_name=$(basename "$selected" | tr . _)

# Check if tmux server is running
tmux_running=$(pgrep tmux)

# Case 1: Not inside tmux, and no server is running → start fresh
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s "$selected_name" -c "$selected"
  exit 0
fi

# Case 2: Inside tmux or server already running
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
  tmux select-window -t "$selected_name:1"
fi

# Switch client to the session
tmux switch-client -t "$selected_name"
