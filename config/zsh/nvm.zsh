export NVM_DIR="$HOME/.nvm"

load_nvm() {
  unset -f load_nvm nvm node npm npx pnpm 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

nvm() {
  load_nvm
  nvm "$@"
}

node() {
  load_nvm
  node "$@"
}

npm() {
  load_nvm
  npm "$@"
}

npx() {
  load_nvm
  npx "$@"
}

pnpm() {
  load_nvm
  pnpm "$@"
}
