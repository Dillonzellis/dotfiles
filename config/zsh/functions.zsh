wip() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  git add -A

  local -a deleted
  deleted=("${(@f)$(git ls-files --deleted 2>/dev/null)}")
  (( ${#deleted} )) && git rm --ignore-unmatch -- "${deleted[@]}"

  git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"
}

fco() {
  local b
  b="$(git branch -r --format='%(refname:short)' | fzf --prompt='checkout> ')"
  [[ -n "$b" ]] && git checkout "$b"
}
