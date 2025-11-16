#!/usr/bin/env bash

set -euo pipefail

WORKSPACE="O"

# 1) Focus / create workspace O
aerospace workspace "$WORKSPACE"

ensure_app_window() {
  local bundle_id="$1"
  local app_name="$2"

  # Try to find an existing window for this app
  local window_id
  window_id="$(
    aerospace list-windows --all \
      --app-bundle-id "$bundle_id" \
      --format '%{window-id}' |
      head -n1 || true
  )"

  # If no window yet, launch the app
  if [[ -z "${window_id:-}" ]]; then
    open -na "$app_name"

    # Wait briefly for a window to appear (up to ~3s)
    for _ in {1..10}; do
      sleep 0.3
      window_id="$(
        aerospace list-windows --all \
          --app-bundle-id "$bundle_id" \
          --format '%{window-id}' |
          head -n1 || true
      )"
      [[ -n "${window_id:-}" ]] && break
    done
  fi

  # If we have a window, move it to workspace O and focus it
  if [[ -n "${window_id:-}" ]]; then
    aerospace move-node-to-workspace \
      --window-id "$window_id" \
      --focus-follows-window \
      "$WORKSPACE"
  fi
}

# 2) Ensure Outlook & Ghostty both end up on workspace O
#    (your on-window-detected rules stay as-is; we override placement *after* they fire)
ensure_app_window "com.microsoft.Outlook" "Microsoft Outlook"
ensure_app_window "com.mitchellh.ghostty" "Ghostty"

# 3) Normalize layout on workspace O to a horizontal 50/50-ish split
aerospace flatten-workspace-tree --workspace "$WORKSPACE"
aerospace layout tiles horizontal
aerospace balance-sizes --workspace "$WORKSPACE"
