plugins=(zsh-autosuggestions zsh-syntax-highlighting)

# PROMPT='%F{green}%n%f@%F{blue}%m%f %F{yellow}%~%f %F{red}$%f '
# PROMPT='%~ '
# PROMPT='%F{#008000}%~ %f% '
# PROMPT='%F{#008080}%~ %f% '
PROMPT='%F{#b5fd89}%~ %f% '

alias cl="clear"
alias ..="cd .."
alias rf="rm -rf"
alias vi="nvim"

alias gs="git status"
alias zshrc="nvim ~/.zshrc"
	
alias ajc="cd ~/dev/arc-fusion-ajc"
alias dawg="cd ~/dev/arc-fusion-dawgnation/"
alias prxy="cd ~/dev/ajc-arc-feed-proxy/"
alias pl="cd ~/dev/ajc-payload/"
alias lam="cd ~/dev/ajc-arc-headless-services/"
alias dl="cd ~/dev/dl"
alias desk="cd ~/Desktop"

alias ns="npx fusion start"


alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export EDITOR=nvim

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$HOME/Library/Python/3.9/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Created by `pipx` on 2025-07-09 21:10:13
export PATH="$PATH:/Users/dillon.ellis/.local/bin"
