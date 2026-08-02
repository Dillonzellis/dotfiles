# Dotfiles

Personal macOS development environment for Zsh, Neovim, tmux, Ghostty, AeroSpace, Git, Homebrew, and a collection of command-line helpers.

## Contents

- [Repository layout](#repository-layout)
- [Zsh](#zsh)
- [Command-line tools](#command-line-tools)
- [Custom scripts](#custom-scripts)
- [Neovim](#neovim)
- [AeroSpace](#aerospace)
- [tmux](#tmux)
- [Ghostty](#ghostty)
- [Git](#git)
- [Homebrew](#homebrew)

## Repository layout

| Path                              | Purpose                                             | Installed at         |
| --------------------------------- | --------------------------------------------------- | -------------------- |
| `Brewfile`                        | Homebrew packages, applications, and fonts          | `~/Brewfile`         |
| `zshrc`                           | Zsh entry point                                     | `~/.zshrc`           |
| `config/zsh/`                     | Environment, aliases, functions, tools, and plugins | `~/.config/zsh/`     |
| `config/nvim/`                    | Neovim configuration                                | `~/.config/nvim/`    |
| `config/ghostty/`                 | Ghostty configuration                               | `~/.config/ghostty/` |
| `config/aerospace/aerospace.toml` | AeroSpace window manager                            | `~/.aerospace.toml`  |
| `tmux.conf`                       | tmux configuration                                  | `~/.tmux.conf`       |
| `gitconfig`                       | Global Git configuration                            | `~/.gitconfig`       |
| `local/bin/`                      | Personal shell commands                             | `~/.local/bin/`      |

## Zsh

The prompt displays the current directory in green. Zsh autosuggestions and syntax highlighting are loaded from Homebrew. NVM is lazy-loaded the first time `nvm`, `node`, `npm`, `npx`, or `pnpm` is used, which keeps shell startup faster.

`~/.local/bin` is added to `PATH`, and Java 17 plus Android SDK paths are exported.

### Aliases

#### Shell and modern command replacements

| Alias  | Expands to         | Purpose                                        |
| ------ | ------------------ | ---------------------------------------------- |
| `cl`   | `clear`            | Clear the terminal                             |
| `..`   | `cd ..`            | Move up one directory                          |
| `rf`   | `rm -rf`           | Recursively force-delete a path; use carefully |
| `vi`   | `nvim`             | Open Neovim                                    |
| `cat`  | `bat`              | View files with syntax highlighting            |
| `df`   | `dysk`             | Show disk usage                                |
| `ls`   | `eza --icons auto` | List files with icons                          |
| `htop` | `btop`             | Open the system resource monitor               |
| `gs`   | `git status`       | Show repository status                         |

#### Nightlight

| Alias | Action                                     |
| ----- | ------------------------------------------ |
| `nl`  | Toggle Nightlight                          |
| `nld` | Set Nightlight temperature to 50           |
| `nln` | Set Nightlight temperature to 100          |
| `nls` | Show status, then prompt for a temperature |

#### Project navigation and development

| Alias    | Action                                                              |
| -------- | ------------------------------------------------------------------- |
| `ajc`    | Go to `~/wks/arc-fusion-ajc`                                        |
| `dawg`   | Go to `~/wks/arc-fusion-dawgnation`                                 |
| `pl`     | Go to `~/wks/ajc-payload`                                           |
| `dl`     | Go to `~/wks/dl`                                                    |
| `desk`   | Go to `~/Desktop`                                                   |
| `ns`     | Run `npx fusion start`                                              |
| `ajcdev` | Start Next.js with Turbopack and Node deprecation warnings disabled |
| `dsu`    | Open the workspace-O Outlook/Ghostty setup                          |
| `topic`  | Run the roadmap topic picker                                        |

### Functions

#### `wip`

Stages all changes, includes deleted tracked files, and creates a local work-in-progress commit without hooks or GPG signing:

```sh
wip
```

Commit message: `--wip-- [skip ci]`

#### `fco`

Uses `fzf` to select and check out a remote branch:

```sh
fco
```

### Navigation tools

- `zoxide` learns frequently used directories. Use `z name` to jump to one.
- `fzf` provides interactive fuzzy selection and is used by several custom commands.
- Zsh autosuggestions proposes commands from history; press the right arrow to accept a suggestion.
- Zsh syntax highlighting colors valid and invalid shell input as it is typed.

## Command-line tools

These are the main Homebrew-installed replacements and utilities exposed by the shell configuration.

| Command   | What it does                                       | Example                |
| --------- | -------------------------------------------------- | ---------------------- |
| `eza`     | Modern `ls` with colors, Git metadata, and icons   | `eza -la --git`        |
| `bat`     | Syntax-highlighted `cat` with paging               | `bat README.md`        |
| `dysk`    | Filesystem and disk-space viewer                   | `dysk`                 |
| `btop`    | Interactive CPU, memory, disk, and process monitor | `btop`                 |
| `rg`      | Fast recursive text search                         | `rg "search term" src` |
| `fd`      | Fast file and directory finder                     | `fd README`            |
| `fzf`     | Interactive fuzzy finder                           | `git branch            | fzf` |
| `zoxide`  | Directory jumper based on usage                    | `z dotfiles`           |
| `yazi`    | Terminal file manager                              | `yazi`                 |
| `lazygit` | Terminal Git interface                             | `lazygit`              |
| `gh`      | GitHub command-line interface                      | `gh pr view --web`     |
| `tree`    | Print a directory tree                             | `tree -L 2`            |
| `btop`    | Interactive system monitor                         | `btop`                 |
| `sk`      | Skim fuzzy finder                                  | `sk`                   |
| `cmatrix` | Matrix-style terminal animation                    | `cmatrix`              |
| `7z`      | Create and extract 7-Zip archives                  | `7z x archive.7z`      |

## Custom scripts

Everything in `local/bin` is available directly because `~/.local/bin` is on `PATH`.

### `gc` — formatted Git commits

Creates a commit using the part of the current branch before `/` as a ticket prefix and adds `-Dillon` to the message.

```sh
# On ABC-123/fixImagePlaceholder:
gc "fix image placeholder"
# Creates: ABC-123/fix image placeholder-Dillon

gc "fix image placeholder" --no-verify
gc "fix image placeholder" --amend
```

On a branch without `/`, only the supplied message and `-Dillon` are used.

### `ggpick` — find ticket commits

Searches commit messages and copies the matching full hashes to the clipboard. With no search term, it uses the current branch prefix.

```sh
ggpick
ggpick SPD-123
ggpick -v "bug fix"
ggpick -T SPD-123
ggpick 'PDEV-975\|PDEV-977'
```

### `grecent` — recent branches

Reads the reflog and prints the ten most recently checked-out branches.

```sh
grecent       # list recent branches
grecent -s    # choose one with fzf and switch to it
```

### `gt` — Ghostty transparency

Reads and modifies opacity and blur in the Ghostty config.

```sh
gt                 # toggle opacity
gt show            # show current opacity and blur
gt 0.8             # set opacity directly
gt blur 20         # set blur radius
gt bt              # toggle blur
gt preset glass    # opacity 0.85, blur 20
gt preset subtle   # opacity 0.95, blur 10
gt preset strong   # opacity 0.75, blur 18
gt preset minimal  # opacity 0.9, blur 5
gt preset clear    # opacity 1.0, blur disabled
gt reset
```

Reload Ghostty with `Cmd-Shift-,` after making a change.

### `dsu` — daily startup workspace

The `dsu` alias runs `dsu-aerospace.sh`. It opens or finds Microsoft Outlook and Ghostty, moves both to AeroSpace workspace `O`, and balances them in a horizontal tiled layout.

```sh
dsu
```

### `tmux-session-dispensary.sh`

Uses `fzf` to choose a project from `~/wks`, `~/dotfiles`, or `~/orgfiles`, then creates or switches to a tmux session named after that directory. It is normally opened with `prefix f` inside tmux.

### `check_unused.sh`

Heuristically scans `src/` in a JavaScript or TypeScript project for files that do not appear to be imported. Framework entry-point files such as `page`, `layout`, and `route` are skipped.

```sh
check_unused.sh
```

Treat its output as candidates for review, not proof that a file is unused.

## Neovim

The configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) as its plugin manager. The leader key is `Space`; the local leader is `\`.

On first launch, lazy.nvim bootstraps itself and installs plugins. Useful maintenance commands:

```vim
:Lazy
:Mason
:checkhealth
:ConformInfo
```

Press `<leader>?` to see buffer-local mappings or `<leader>fk` to search all currently active mappings.

### Core editing

| Key                      | Action                                            |
| ------------------------ | ------------------------------------------------- |
| `Ctrl-s`                 | Save the current file                             |
| `<leader>w`              | Toggle line wrapping                              |
| `<leader>ln`             | Toggle relative line numbers                      |
| `<leader>la`             | Open lazy.nvim                                    |
| `<leader>bs`             | Create a scratch buffer                           |
| `<leader>bm`             | Copy `:messages` into a scratch buffer            |
| `<leader>d`              | Delete without replacing the yank register        |
| `J`                      | Join lines without moving the cursor              |
| `K` / `J` in visual mode | Move the selected lines up/down                   |
| `n` / `N`                | Move through search results and center the screen |
| `Ctrl-d` / `Ctrl-u`      | Move half a page and center the screen            |
| `<leader>pA`             | Copy the absolute path of the current file        |
| `<leader>pa`             | Copy its Git-root-relative path                   |

`Q` and `F1` are disabled. The system clipboard is used by default, splits open below and to the right, tabs use two spaces, and swap/backup files are disabled.

### Find files and text

| Key                | Action                             |
| ------------------ | ---------------------------------- |
| `<leader><leader>` | Find files with MiniPick           |
| `<leader>fb`       | Find open buffers                  |
| `<leader>fg`       | Live grep with ripgrep             |
| `<leader>fG`       | Grep with ripgrep                  |
| `<leader>fw`       | Grep the word under the cursor     |
| `<leader>fk`       | Search all keymaps                 |
| `<leader>e`        | Toggle Neo-tree                    |
| `<leader>ge`       | Toggle Neo-tree Git status view    |
| `-`                | Open the parent directory with Oil |

### LSP, completion, and diagnostics

Mason manages language servers. The configuration includes TypeScript/JavaScript, Lua, HTML, CSS, Bash, JSON, Tailwind CSS, and ESLint support. Completion comes from `nvim-cmp` with LSP, buffer, path, and command-line sources.

| Key                     | Action                   |
| ----------------------- | ------------------------ |
| `gd`                    | Go to definition         |
| `gr`                    | Find references          |
| `gI`                    | Go to implementation     |
| `gy`                    | Go to type definition    |
| `gD`                    | Go to declaration        |
| `K`                     | Show hover documentation |
| `gK`                    | Show signature help      |
| `Ctrl-k` in insert mode | Show signature help      |
| `<leader>ca`            | Show code actions        |
| `<leader>cr`            | Rename symbol            |
| `<leader>cc`            | Run code lens            |
| `<leader>cd`            | Open diagnostic details  |
| `]d` / `[d`             | Next/previous diagnostic |
| `]e` / `[e`             | Next/previous error      |
| `]w` / `[w`             | Next/previous warning    |
| `<leader>ud`            | Toggle diagnostics       |
| `<leader>uh`            | Toggle inlay hints       |

Completion menu:

| Key                 | Action                          |
| ------------------- | ------------------------------- |
| `Ctrl-Space`        | Open completion                 |
| `Ctrl-n` / `Ctrl-p` | Select next/previous item       |
| `Ctrl-y`            | Accept selected completion      |
| `Ctrl-e`            | Close completion                |
| `Ctrl-f` / `Ctrl-b` | Scroll completion documentation |

### Formatting

Conform formats on save and falls back to the attached LSP. Configured formatters include Prettierd/Prettier, Stylua, isort/Black, and shfmt.

| Key          | Action                                        |
| ------------ | --------------------------------------------- |
| `<leader>cf` | Format the current buffer or visual selection |
| `<leader>uf` | Toggle format-on-save globally                |

Use `:ConformInfo` to see which formatter is active for the current file.

### Git

| Key          | Action                                          |
| ------------ | ----------------------------------------------- |
| `<leader>gg` | Open LazyGit                                    |
| `]c` / `[c`  | Next/previous changed hunk                      |
| `<leader>hs` | Stage hunk                                      |
| `<leader>hr` | Reset hunk                                      |
| `<leader>hS` | Stage the entire buffer                         |
| `<leader>hu` | Undo staged hunk                                |
| `<leader>hR` | Reset the entire buffer                         |
| `<leader>hp` | Preview hunk                                    |
| `<leader>hd` | Diff current file                               |
| `<leader>hD` | Diff current file against the previous revision |
| `<leader>gl` | Show full blame for the current line            |
| `<leader>gL` | Toggle inline line blame                        |
| `<leader>gB` | Open the current file and line in the Git host  |
| `<leader>gf` | Pick changed Git files                          |
| `<leader>gh` | Pick Git hunks                                  |
| `<leader>gb` | Pick Git branches                               |
| `<leader>gc` | Pick Git commits                                |

### Harpoon

| Key                             | Action                          |
| ------------------------------- | ------------------------------- |
| `<leader>H`                     | Add the current file to Harpoon |
| `<leader>h`                     | Open the Harpoon menu           |
| `<leader>1` through `<leader>9` | Jump to a Harpoon file          |

### Movement, windows, and folds

| Key                              | Action                                    |
| -------------------------------- | ----------------------------------------- |
| `s`                              | Leap to a visible location                |
| `S`                              | Leap from another window                  |
| `Enter` / `Backspace` after Leap | Repeat forward/backward                   |
| `Ctrl-h/j/k/l`                   | Move between Neovim splits and tmux panes |
| `zR`                             | Open all folds                            |
| `zM`                             | Close all folds                           |
| `zK`                             | Preview the fold under the cursor         |

Treesitter text objects are available in visual and operator-pending modes:

| Key         | Object               |
| ----------- | -------------------- |
| `af` / `if` | Outer/inner function |
| `ac` / `ic` | Outer/inner class    |

### Other plugins

| Key or command | Action                                                      |
| -------------- | ----------------------------------------------------------- |
| `<leader>ct`   | Toggle masking of `.env` and other secret values with Cloak |
| `<leader>cp`   | Preview the real value on the current Cloak line            |
| `<leader>i`    | Toggle indent guides                                        |
| `<leader>xx`   | Toggle workspace diagnostics with Trouble                   |
| `<leader>xX`   | Toggle current-buffer diagnostics                           |
| `<leader>cs`   | Toggle document symbols                                     |
| `<leader>cl`   | Toggle LSP definitions/references view                      |
| `<leader>xL`   | Toggle location list                                        |
| `<leader>xQ`   | Toggle quickfix list                                        |
| `:TodoTrouble` | View TODO-style comments                                    |

Additional behavior:

- TokyoNight is the colorscheme.
- Treesitter installs parsers for common web languages plus Lua, Bash, Python, Rust, Go, and C.
- Traditional Vim syntax highlighting is enabled as a fallback alongside Treesitter.
- Hardtime discourages repetitive basic movement keys.
- Orgmode support is enabled for `.org` files.
- Yanked text is briefly highlighted.

## AeroSpace

AeroSpace starts at login and uses tiled workspaces with 10-pixel inner and outer gaps. Focused windows and monitors pull the mouse pointer to the focused area.

### Window navigation and layout

| Key                           | Action                                 |
| ----------------------------- | -------------------------------------- |
| `Alt-h/j/k/l`                 | Focus left/down/up/right               |
| `Alt-Shift-h/j/k/l`           | Move window left/down/up/right         |
| `Alt-Shift--` / `Alt-Shift-=` | Shrink/grow the focused window         |
| `Alt-/`                       | Cycle tiled orientation                |
| `Alt-,`                       | Use accordion layout                   |
| `Alt-Shift-f`                 | Toggle fullscreen                      |
| `Alt-Tab`                     | Switch to the previous workspace       |
| `Alt-Shift-Tab`               | Move the workspace to the next monitor |

### Workspaces

`Alt-<workspace>` focuses a workspace. `Alt-Shift-<workspace>` moves the current window there.

Configured workspaces include `1` through `9` and most letter keys. Four applications are assigned automatically:

| Workspace | Application   |
| --------- | ------------- |
| `B`       | Google Chrome |
| `G`       | Ghostty       |
| `S`       | Slack         |
| `M`       | Spotify       |

Workspace `O` is used by the custom `dsu` Outlook/Ghostty startup command.

### Service mode

Press `Alt-Shift-;` to enter service mode, then use one command:

| Key                 | Action                                                |
| ------------------- | ----------------------------------------------------- |
| `Esc`               | Reload configuration                                  |
| `r`                 | Flatten/reset the workspace layout                    |
| `f`                 | Toggle the focused window between floating and tiling |
| `Backspace`         | Close every window except the current one             |
| `Alt-Shift-h/j/k/l` | Join the window with a container in that direction    |

## tmux

The tmux prefix is `Ctrl-a`. Press `Ctrl-a` once, release it, then press the command key.

| Key                           | Action                                                 |
| ----------------------------- | ------------------------------------------------------ |
| `prefix \|`                   | Split horizontally                                     |
| `prefix -`                    | Split vertically                                       |
| `prefix h/j/k/l`              | Resize the current pane by five cells                  |
| `prefix m`                    | Toggle pane zoom                                       |
| `Ctrl-h/j/k/l`                | Move between panes or Neovim splits without the prefix |
| `Ctrl-\`                      | Move to the last pane                                  |
| `prefix 0` through `prefix 9` | Switch to the numbered session                         |
| `prefix o`                    | Switch to `orgfiles`                                   |
| `prefix d`                    | Switch to `dotfiles`                                   |
| `prefix a`                    | Switch to `ajc-payload`                                |
| `prefix Tab`                  | Switch to the previous session                         |
| `prefix f`                    | Open the fuzzy project/session picker                  |
| `prefix r`                    | Reload `~/.tmux.conf`                                  |

Mouse support is enabled. Windows start at index 2, panes start at index 1, and windows are automatically renumbered.

### Copy mode

Copy mode uses vi keys. Enter it with `prefix [`.

| Key        | Action                                         |
| ---------- | ---------------------------------------------- |
| `v`        | Begin selection                                |
| `V`        | Select the line                                |
| `r`        | Toggle rectangle selection                     |
| `y`        | Copy selection to the macOS clipboard and exit |
| `Y`        | Copy the line to the macOS clipboard and exit  |
| `prefix ]` | Paste the tmux buffer                          |

## Ghostty

Current appearance:

- Theme: Kanagawa Dragon
- Font: 0xProto Nerd Font, 15 pt
- Background opacity: 0.9
- Background blur: 10
- Window title: blank
- Trailing spaces are trimmed when copying

Use the custom [`gt`](#gt--ghostty-transparency) command to change transparency and blur. Reload configuration with `Cmd-Shift-,`.

## Git

Global behavior configured in `gitconfig`:

- New repositories use `master` as the default branch.
- `git push` automatically establishes the upstream remote.
- Diffs use the patience algorithm.
- Neovim is the default editor.
- Git LFS filters are configured.
- Reuse recorded resolution (`rerere`) is disabled.

The [`gc`](#gc--formatted-git-commits), [`ggpick`](#ggpick--find-ticket-commits), and [`grecent`](#grecent--recent-branches) commands provide the main custom Git workflows.

## Homebrew

Install everything declared in the Brewfile:

```sh
brew bundle --file=~/dotfiles/Brewfile
```

Check what would change without installing anything:

```sh
brew bundle check --file=~/dotfiles/Brewfile
```

Remove formulae not present in the Brewfile only after reviewing the list:

```sh
brew bundle cleanup --file=~/dotfiles/Brewfile
```

### Installed groups

| Group            | Packages                                                                                           |
| ---------------- | -------------------------------------------------------------------------------------------------- |
| Core development | Git, GitHub CLI, Neovim, tmux, curl, wget, GCC                                                     |
| Language tooling | Node, NVM, pnpm, Lua language server, Bash language server, VS Code HTML/CSS/JSON language servers |
| Terminal tools   | fzf, ripgrep, fd, eza, bat, dysk, btop, zoxide, Yazi, tree, Skim, cmatrix                          |
| Archives         | p7zip, unzip, gzip                                                                                 |
| Git UI           | LazyGit                                                                                            |
| Fonts            | 0xProto Nerd Font, Fira Code Nerd Font, JetBrains Mono Nerd Font                                   |
| macOS utilities  | mas, Mackup, Nightlight, f.lux                                                                     |
| Applications     | Ghostty, Figma, AeroSpace, Firefox, Google Chrome, VLC                                             |

Commented entries in the Brewfile are optional tools that are not installed by `brew bundle` in the current configuration.
