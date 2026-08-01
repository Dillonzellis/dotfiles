return {
	"stevearc/conform.nvim",

	event = { "BufWritePre" },
	cmd = { "ConformInfo" },

	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({
					async = true,
				})
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},

	opts = {
		-- Defaults used by manual formatting and format-on-save
		default_format_opts = {
			lsp_format = "fallback",
		},

		formatters_by_ft = {
			lua = { "stylua" },

			-- These run sequentially
			python = { "isort", "black" },

			-- Use prettierd first, then prettier if prettierd is unavailable
			javascript = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			javascriptreact = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			typescript = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			typescriptreact = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			css = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			html = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			json = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			yaml = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			markdown = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},

			bash = { "shfmt" },
			sh = { "shfmt" },
		},

		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end

			return {
				timeout_ms = 3000,
			}
		end,
	},
}
