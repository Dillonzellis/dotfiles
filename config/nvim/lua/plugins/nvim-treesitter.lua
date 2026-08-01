local parsers = {
	"c",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"javascript",
	"typescript",
	"ecma",
	"jsx",
	"html_tags",
	"tsx",
	"html",
	"css",
	"json",
	"bash",
	"python",
	"rust",
	"go",
}

local filetypes = {
	"c",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"html",
	"css",
	"json",
	"jsonc",
	"sh",
	"python",
	"rust",
	"go",
}

return {
	{
		"neovim-treesitter/nvim-treesitter",

		dependencies = {
			"neovim-treesitter/treesitter-parser-registry",
		},

		lazy = false,
		build = ":TSUpdate",

		config = function()
			local treesitter = require("nvim-treesitter")

			-- Install any missing parsers.
			-- Calling install is a no-op for parsers already installed.
			treesitter.install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = filetypes,

				callback = function()
					-- Syntax highlighting
					vim.treesitter.start()

					-- Treesitter-based indentation
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",

		dependencies = {
			"neovim-treesitter/nvim-treesitter",
		},

		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
			})

			local select = require("nvim-treesitter-textobjects.select")

			vim.keymap.set({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer", "textobjects")
			end, { desc = "Outer function" })

			vim.keymap.set({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner", "textobjects")
			end, { desc = "Inner function" })

			vim.keymap.set({ "x", "o" }, "ac", function()
				select.select_textobject("@class.outer", "textobjects")
			end, { desc = "Outer class" })

			vim.keymap.set({ "x", "o" }, "ic", function()
				select.select_textobject("@class.inner", "textobjects")
			end, { desc = "Inner class" })
		end,
	},
}
