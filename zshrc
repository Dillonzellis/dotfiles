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


wip() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  git add -A

  local -a deleted
  deleted=("${(@f)$(git ls-files --deleted 2>/dev/null)}")
  (( ${#deleted} )) && git rm --ignore-unmatch -- "${deleted[@]}"

  git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"
}

gc() {
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ "$branch" == *"/"* ]]; then
        prefix=$(echo "$branch" | sed 's/\/.*//')
        git commit -m "$prefix/$*-Dillon"
    else
        git commit -m "$*-Dillon"
    fi
}

grecent() {
  git reflog --date=short |
    grep 'checkout:' |
    sed -E 's/.* to ([^ ]+).*/\1/' |
    awk '!seen[$0]++' |
    head
}

fco() {
  local b
  b="$(git branch -r --format='%(refname:short)' | fzf --prompt='checkout> ')"
  [[ -n "$b" ]] && git checkout "$b"
}

alias dsu='~/.local/bin/dsu-aerospace.sh'

export EDITOR=nvim

export PATH="$HOME/.local/bin:$PATH"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$HOME/Library/Python/3.9/bin:$PATH"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# export PATH=$PATH:/Users/dillon.ellis/.spicetify

# export PATH=$PATH:/Users/dillonellis/.spicetify
