return {
	"christoomey/vim-tmux-navigator",
	"github/copilot.vim",
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	{
		"kdheepak/lazygit.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>")
		end,
	},
}
