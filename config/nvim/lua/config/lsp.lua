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
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
	vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
	vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
	vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
	vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
	vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

	-- Code actions
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
	vim.keymap.set("n", "<leader>cc", vim.lsp.codelens.run, vim.tbl_extend("force", opts, { desc = "Run codelens" }))
	vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, vim.tbl_extend("force", opts, { desc = "Refresh codelens" }))
	vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))


	-- Diagnostics
	vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Open diagnostic float" }))
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
	vim.keymap.set("n", "]e", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, vim.tbl_extend("force", opts, { desc = "Next error" }))
	vim.keymap.set("n", "[e", function()
		vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, vim.tbl_extend("force", opts, { desc = "Previous error" }))
	vim.keymap.set("n", "]w", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
	end, vim.tbl_extend("force", opts, { desc = "Next warning" }))
	vim.keymap.set("n", "[w", function()
		vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
	end, vim.tbl_extend("force", opts, { desc = "Previous warning" }))
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
		vim.api.nvim_create_autocmd("CursorHold", {
			group = "lsp_document_highlight",
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = "lsp_document_highlight",
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end


end

-- Status line integration (cached, updated only on LSP attach/detach)
local lsp_status_cache = ""

function M.get_lsp_status()
	return lsp_status_cache
end

-- Japanese mode display for statusline
_G.j_mode = function()
	local m = vim.api.nvim_get_mode().mode
	local map = {
		n = "通常",
		no = "通常",
		i = "挿入",
		ic = "挿入",
		v = "ビジュアル",
		V = "行ビジュアル",
		["\22"] = "矩形",
		c = "コマンド",
		R = "置換",
		Rx = "仮置換",
		s = "選択",
		S = "行選択",
		t = "ターミナル",
	}
	return map[m] or m
end

-- Korean mode display for statusline
_G.k_mode = function()
	local m = vim.api.nvim_get_mode().mode
	local map = {
		n = "일반",
		no = "일반",
		i = "삽입",
		ic = "삽입",
		v = "비주얼",
		V = "줄비주얼",
		["\22"] = "블록",
		c = "명령",
		R = "교체",
		Rx = "가교체",
		s = "선택",
		S = "줄선택",
		t = "터미널",
	}
	return map[m] or m
end

-- Main setup function
function M.setup()
	M.setup_diagnostics()

	vim.o.showmode = false

	vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
		callback = function()
			vim.schedule(function()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if #clients == 0 then
					lsp_status_cache = ""
				else
					local names = {}
					for _, c in ipairs(clients) do
						table.insert(names, c.name)
					end
					lsp_status_cache = "[LSP: " .. table.concat(names, ",") .. "]"
				end
				vim.cmd.redrawstatus()
			end)
		end,
	})

	vim.o.statusline = "%{%v:lua.k_mode()%} %f %m%r%h%w [%{&ft}] %{v:lua.require('config.lsp').get_lsp_status()} %= %l,%c %P"
end

return M
