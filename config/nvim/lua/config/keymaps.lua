vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>ud", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })

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
