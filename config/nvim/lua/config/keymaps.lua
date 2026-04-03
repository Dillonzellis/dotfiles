vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>w", ":set wrap!<CR>", { desc = "Toggle Wrap" })
vim.keymap.set("n", "<leader>ln", ":set relativenumber!<CR>", { desc = "Toggle Relative Number" })
vim.keymap.set("n", "<leader>la", "<cmd>Lazy<CR>", { desc = "Show Lazy Menu" })

vim.keymap.set("n", "<leader>ud", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })

vim.keymap.set("n", "<leader>uf", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	print("Format on save: " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
end, { desc = "Toggle Format on Save" })

vim.keymap.set(
	"n",
	"<leader>bs",
	"<cmd>:enew | setlocal buftype=nofile bufhidden=hide noswapfile<CR>",
	{ desc = "Create Scratch Buffer" }
)

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered on screen)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered on screen)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv", { desc = "Move line up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

vim.keymap.set("n", "<C-s>", ":update<CR>", { desc = "Save file" })

vim.keymap.set("n", "<leader>bm", function()
	vim.cmd("enew | setlocal buftype=nofile bufhidden=hide noswapfile")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(vim.fn.execute("messages"), "\n"))
end, { desc = "Messages to scratch buffer" })
