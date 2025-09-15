return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	opts = {
		enabled = false,
	},
	keys = {
		{ "<leader>i", "<cmd>IBLToggle<cr>", desc = "Indent Lines Toggle" },
	},
}
