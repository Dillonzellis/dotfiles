return {
	"laytan/cloak.nvim",
	opts = {
		enabled = false,
		cloak_character = "*",
		highlight_group = "Comment",
		try_all_patterns = true,
		patterns = {
			{
				file_pattern = { "*" },
				cloak_pattern = "=.+",
				replace = "",
			},
		},
	},
	keys = {
		{
			"leader>uct",
			"<cmd>CloakToggle<CR>",
			desc = "Toggle cloak",
			mode = "n",
		},
		{
			"<leader>ucp",
			"<cmd>CloakPreviewLine<CR>",
			desc = "Preview cloaked line",
			mode = "n",
		},
	},
}
