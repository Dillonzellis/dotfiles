return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		opts = {
			window = {
				position = "right",
			},
		},
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
			{ "<leader>ge", "<cmd>Neotree toggle git_status<cr>", desc = "Toggle Neotree with git status" },
		},
		lazy = false, -- neo-tree will lazily load itself
	},
}
