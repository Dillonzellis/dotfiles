vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

vim.o.updatetime = 300
vim.o.cursorline = true

vim.o.mouse = "a"

vim.o.smartindent = true
vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

vim.o.wildmenu = true

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.ignorecase = true
vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.clipboard = "unnamedplus"
vim.o.winborder = "rounded"

vim.o.timeoutlen = 300

vim.o.backspace = "indent,eol,start"

vim.o.winbar = "%=%m %f"
vim.o.sidescrolloff = 8

-- Enhanced options for better LSP experience
vim.o.updatetime = 250
vim.o.completeopt = "menu,menuone,noselect"
vim.o.pumheight = 10

vim.opt.guicursor =
"n-v-c:block-blinkwait700-blinkoff400-blinkon250,i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250,r-cr:hor20,o:hor50,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Better diff options
vim.opt.diffopt:append("linematch:60")

vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000
