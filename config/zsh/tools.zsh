[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

eval "$(zoxide init zsh)"

[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
