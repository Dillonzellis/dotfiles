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

-- Helper: get git root or cwd as fallback
local function get_project_root()
	-- Try git root
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error == 0 and git_root and git_root ~= "" then
		return git_root
	end

	-- Fallback: current working directory
	return vim.fn.getcwd()
end

-- Helper: make path relative to base
local function relpath(path, base)
	if not path or not base then
		return path
	end

	-- Normalize to remove trailing slash on base
	base = base:gsub("/$", "")

	if path:sub(1, #base) == base then
		local offset = #base + 2 -- +1 for slash, +1 to start after it
		return path:sub(offset)
	end

	-- If it doesn't share the prefix, just return original
	return path
end

-- Copy Absolute File-Path
vim.keymap.set("n", "<leader>pA", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file (abs):", path)
end, { desc = "Copy absolute file path" })

-- Copy Project-Relative File-Path (git root -> cwd)
vim.keymap.set("n", "<leader>pa", function()
	local abs = vim.fn.expand("%:p")
	local root = get_project_root()
	local rel = relpath(abs, root)

	vim.fn.setreg("+", rel)
	print("file (proj-rel):", rel)
end, { desc = "Copy file path (git root-relative)" })

-- Open Org files fully expanded
vim.api.nvim_create_autocmd("FileType", {
	pattern = "org",
	callback = function()
		vim.opt_local.foldlevel = 99 -- keep folds open
		vim.opt_local.foldlevelstart = 99
	end,
})
