-- LSP configuration
local M = {}

-- Enhanced Diagnostics Configuration (updated for Neovim 0.11+)
function M.setup_diagnostics()
	vim.diagnostic.config({
		underline = true,
		update_in_insert = false,
		virtual_text = {
			spacing = 4,
			source = "if_many",
			prefix = "●",
		},
		severity_sort = true,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.HINT] = " ",
				[vim.diagnostic.severity.INFO] = " ",
			},
			-- Removed linehl and numhl as they are deprecated
		},
		float = {
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})
end

-- LSP Keymaps (updated for Neovim 0.11+)
function M.setup_lsp_keymaps(bufnr)
	local opts = { buffer = bufnr, silent = true }

	-- Navigation
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, opts)

	-- Code actions
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>cc", vim.lsp.codelens.run, opts)
	vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, opts)
	vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

	-- Formatting
	vim.keymap.set({ "n", "v" }, "<leader>cf", function()
		vim.lsp.buf.format({ async = true })
	end, opts)

	-- Toggle auto-format
	vim.keymap.set("n", "<leader>cF", function()
		M.toggle_autoformat_buffer()
	end, opts)
	vim.keymap.set("n", "<leader>cG", function()
		M.toggle_autoformat_global()
	end, opts)

	-- Diagnostics
	vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]e", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, opts)
	vim.keymap.set("n", "[e", function()
		vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, opts)
	vim.keymap.set("n", "]w", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
	end, opts)
	vim.keymap.set("n", "[w", function()
		vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
	end, opts)
end

-- LSP Capabilities (updated for better compatibility)
function M.get_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	-- Add completion capabilities from nvim-cmp
	local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
	if has_cmp then
		capabilities = cmp_lsp.default_capabilities(capabilities)
	end

	-- Folding capabilities for nvim-ufo
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	return capabilities
end

-- Auto-format state tracking
local autoformat_enabled = true
local autoformat_buffer_disabled = {}

-- Toggle auto-format globally
function M.toggle_autoformat_global()
	autoformat_enabled = not autoformat_enabled
	if autoformat_enabled then
		vim.notify("Auto-format enabled globally", vim.log.levels.INFO)
	else
		vim.notify("Auto-format disabled globally", vim.log.levels.WARN)
	end
end

-- Toggle auto-format for current buffer
function M.toggle_autoformat_buffer()
	local bufnr = vim.api.nvim_get_current_buf()
	autoformat_buffer_disabled[bufnr] = not autoformat_buffer_disabled[bufnr]

	if autoformat_buffer_disabled[bufnr] then
		vim.notify("Auto-format disabled for this buffer", vim.log.levels.WARN)
	else
		vim.notify("Auto-format enabled for this buffer", vim.log.levels.INFO)
	end
end

-- Check if auto-format is enabled for current buffer
local function should_format(bufnr)
	return autoformat_enabled and not autoformat_buffer_disabled[bufnr]
end

-- LSP on_attach function (updated for Neovim 0.11+)
function M.on_attach(client, bufnr)
	M.setup_lsp_keymaps(bufnr)

	-- Enable inlay hints if supported
	if client.supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	-- Highlight symbol under cursor
	if client.supports_method("textDocument/documentHighlight") then
		vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = "lsp_document_highlight",
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = "lsp_document_highlight",
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	-- Auto-format on save (with toggle support)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
			buffer = bufnr,
			callback = function()
				if should_format(bufnr) then
					vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
				end
			end,
		})
	end

	-- ⭐ NEW: Run ESLint code actions on save for JS/TS files
	local ft = vim.bo[bufnr].filetype
	if ft == "javascript" or ft == "javascriptreact" or ft == "typescript" or ft == "typescriptreact" then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("EslintFixAll." .. bufnr, {}),
			buffer = bufnr,
			callback = function()
				-- Run ESLint fix all code action
				vim.lsp.buf.code_action({
					context = {
						only = { "source.fixAll.eslint" },
						diagnostics = {},
					},
					apply = true,
				})
			end,
		})
	end
end

-- Setup floating window handlers
function M.setup_handlers()
	-- Customize LSP floating windows
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

-- Status line integration (updated for Neovim 0.11+)
function M.get_lsp_status()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return ""
	end

	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end

	return "[LSP: " .. table.concat(names, ",") .. "]"
end

-- Main setup function
function M.setup()
	M.setup_diagnostics()
	M.setup_handlers()

	-- Setup status line
	vim.o.statusline = "%f %m%r%h%w [%{&ff}] [%{&ft}] %{v:lua.require('config.lsp').get_lsp_status()} %= %l,%c %P"
end

return M
