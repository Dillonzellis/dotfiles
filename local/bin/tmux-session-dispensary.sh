#!/usr/bin/env bash
set -euo pipefail

DIRS=(
  "$HOME/wks"
  "$HOME/dotfiles"
  "$HOME/orgfiles"
)

FD_BIN="$(command -v fd || command -v fdfind || true)"

if ! command -v fzf >/dev/null 2>&1; then
  echo "Missing dependency: fzf" >&2
  exit 1
fi

list_paths() {
  for dir in "${DIRS[@]}"; do
    if [[ "$dir" == "$HOME/wks" ]]; then
      if [[ -n "${FD_BIN}" ]]; then
        "$FD_BIN" --type d --max-depth 1 . "$dir"
      else
        find "$dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null
      fi
    else
      echo "$dir"
    fi
  done
}

# Use a tmux popup when inside tmux + tmux supports it; otherwise normal fzf
fzf_pick() {
  if [[ -n "${TMUX:-}" ]] && tmux display-message -p '#{popup_supported}' 2>/dev/null | grep -q 1; then
    # run fzf in a popup and print selection
    tmux popup -E -w 80% -h 70% "cat | fzf --prompt='session> '"
  else
    fzf --prompt='session> '
  fi
}

selected="$(
  list_paths |
    sed "s|^$HOME/||" |
    fzf_pick
)"

# If user hit Enter without selecting
if [[ -z "${selected}" ]]; then
  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -l || true
  fi
  exit 0
fi

selected="$HOME/$selected"
selected_name="$(basename "$selected" | tr . _)"

if [[ -z "${TMUX:-}" ]]; then
  # outside tmux: attach or create in one shot
  tmux new-session -A -s "$selected_name" -c "$selected"
  exit 0
fi

# inside tmux: create if missing, then switch
if ! tmux has-session -t "$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
