wip() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  git add -A

  local -a deleted
  deleted=("${(@f)$(git ls-files --deleted 2>/dev/null)}")
  (( ${#deleted} )) && git rm --ignore-unmatch -- "${deleted[@]}"

  git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"
}

gc() {
  local branch prefix

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
