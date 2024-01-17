vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- use system clipboard as default register
vim.opt.clipboard:append("unnamedplus")

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x')

vim.keymap.set("n", "<C-m>", ":Ex<CR>")

vim.keymap.set("n", "<C-s>", ":w<CR>")

vim.keymap.set("n", "<leader>r", ":set invwrap<CR>")

-- replace word under cursor throughout file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- disable Q
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
