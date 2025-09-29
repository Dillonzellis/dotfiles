# plugins=(zsh-autosuggestions zsh-syntax-highlighting)
plugins=(zsh-syntax-highlighting)
# setopt CORRECT_ALL

PROMPT='%F{#b5fd89}%~ %f% '

alias cl="clear"
alias ..="cd .."
alias rf="rm -rf"
alias vi="nvim"
alias cat="bat"
alias df="dysk"
alias ls="eza --icons"

alias gs="git status"

alias nl="nightlight toggle"
alias nld="nightlight temp 50"
alias nln="nightlight temp 100"
alias nls="nightlight status && nightlight temp"
	
alias ajc="cd ~/wks/arc-fusion-ajc"
alias dawg="cd ~/wks/arc-fusion-dawgnation/"
alias pl="cd ~/wks/ajc-payload/"
alias dl="cd ~/wks/dl"
alias desk="cd ~/Desktop"

alias ns="npx fusion start"


gc() {
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ "$branch" == *"/"* ]]; then
        prefix=$(echo "$branch" | sed 's/\/.*//')
        git commit -m "$prefix/$*-Dillon"
    else
        git commit -m "$*-Dillon"
    fi
}

export EDITOR=nvim

# Add local bin to PATH (portable across users)
export PATH="$HOME/.local/bin:$PATH"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$HOME/Library/Python/3.9/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"
