vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>w", ":set wrap!<CR>", { desc = "Toggle Wrap" })
vim.keymap.set("n", "<leader>ln", ":set relativenumber!<CR>", { desc = "Toggle Relative Number" })
vim.keymap.set("n", "<leader>la", "<cmd>Lazy<CR>", { desc = "Show Lazy Menu" })

vim.keymap.set("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })

vim.keymap.set(
  "n",
  "<leader>bs",
  "<cmd>:enew | setlocal buftype=nofile bufhidden=hide noswapfile<CR>",
  { desc = "Create Scratch Budder" }
)

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered on screen)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered on screen)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv", { desc = "Move line up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })

vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Global LSP keymaps (not buffer-specific)
vim.keymap.set("n", "<C-s>", ":update<CR>")
-- vim.keymap.set("n", "<leader>lf", function()
-- 	vim.lsp.buf.format({ async = true })
-- end)

-- Enhanced diagnostic keymaps
-- vim.keymap.set('n', '<leader>xl', '<cmd>lopen<cr>', { desc = "Location List" })
-- vim.keymap.set('n', '<leader>xq', '<cmd>copen<cr>', { desc = "Quickfix List" })

-- LSP workspace commands
-- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = "Add Workspace Folder" })
-- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = "Remove Workspace Folder" })
-- vim.keymap.set('n', '<leader>wl', function()
--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end, { desc = "List Workspace Folders" })
