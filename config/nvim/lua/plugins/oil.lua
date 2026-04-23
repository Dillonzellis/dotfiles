return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		view_options = {
			-- Show files and directories that start with "."
			show_hidden = true,
		},
	},
	keys = {
		{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
	},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
}
