-- Commands
vim.cmd("hi statusline guibg=NONE")

-- Auto-commands for better LSP experience
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client then
			-- Enable completion triggered by <c-x><c-o>
			vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
		end
	end,
})

-- automatically highlight yanked text
local HlGrp = vim.api.nvim_create_augroup("highlighter", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = HlGrp,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Copy Full File-Path
vim.keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end)

-- Open Org files fully expanded
vim.api.nvim_create_autocmd("FileType", {
	pattern = "org",
	callback = function()
		vim.opt_local.foldlevel = 99 -- keep folds open
		vim.opt_local.foldlevelstart = 99
	end,
})
