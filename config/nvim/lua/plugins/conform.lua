return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				bash = { "shfmt" },
				sh = { "shfmt" },
			},
			format_on_save = function()
				if vim.g.disable_autoformat then
					return
				end
				return {
					timeout_ms = 3000,
					lsp_fallback = true,
				}
			end,
			formatters = {
				prettier = {
					options = {
						ft_parsers = {
							javascript = "babel",
							javascriptreact = "babel",
							typescript = "typescript",
							typescriptreact = "tsx",
						},
					},
				},
			},
		})
	end,
}
