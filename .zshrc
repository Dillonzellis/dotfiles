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


config() {
    # Check if user is trying to add current directory
    if [[ "$1" == "add" && "$2" == "." ]]; then
        echo "🚫 Error: 'config add .' is dangerous in a bare repository setup!"
        echo "   This would add your entire home directory."
        echo ""
        echo "💡 Instead, use:"
        echo "   config add .zshrc .gitconfig Brewfile    # Add specific files"
        echo "   config add .config/nvim/                 # Add specific directories"
        echo "   config add -i                           # Interactive add"
        echo ""
        echo "🔍 To see what's changed:"
        echo "   config status --untracked-files=normal"
        return 1
    fi
    
    # Check for other potentially dangerous patterns
    if [[ "$1" == "add" && "$2" == "*" ]]; then
        echo "🚫 Error: 'config add *' is also dangerous!"
        echo "   Use specific file paths instead."
        return 1
    fi
    
    # Execute the actual git command
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}

export EDITOR=nvim

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$HOME/Library/Python/3.9/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Created by `pipx` on 2025-07-09 21:10:13
export PATH="$PATH:/Users/dillon.ellis/.local/bin"
