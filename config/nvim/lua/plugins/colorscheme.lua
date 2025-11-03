return {
	-- Currently active colorscheme
	-- {
	--   "folke/tokyonight.nvim",
	--   lazy = false,
	--   priority = 1000,
	--   opts = {
	--     style = "moon", -- storm, moon, night, day
	--     transparent = true,
	--     styles = {
	--       sidebars = "transparent",
	--       floats = "transparent",
	--     },
	--   },
	--   config = function(_, opts)
	--     require("tokyonight").setup(opts)
	--     vim.cmd.colorscheme("tokyonight")
	--   end,
	-- },

	-- {
	--   "ellisonleao/gruvbox.nvim",
	--   lazy = false,
	--   priority = 1000,
	--   opts = {
	--     transparent_mode = true,
	--   },
	--   config = function(_, opts)
	--     require("gruvbox").setup(opts)
	--     vim.cmd.colorscheme("gruvbox")
	--   end,
	-- },

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				transparent = true,
				colors = {
					theme = {
						all = {
							ui = {
								bg_gutter = "none",
							},
						},
					},
				},
			})
			vim.cmd.colorscheme("kanagawa")
		end,
	},

	-- {
	-- 	"EdenEast/nightfox.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("nightfox").setup({
	-- 			options = {
	-- 				transparent = true,
	-- 				terminal_colors = true,
	-- 			},
	-- 		})
	-- 		vim.cmd.colorscheme("carbonfox") -- or nightfox, dawnfox, etc.
	-- 	end,
	-- },

	-- {
	-- 	"neanias/everforest-nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("everforest").setup({
	-- 			background = "medium", -- soft, medium, hard
	-- 			transparent_background_level = 2,
	-- 		})
	-- 		vim.cmd.colorscheme("everforest")
	-- 	end,
	-- },

	-- {
	--   "scottmckendry/cyberdream.nvim",
	--   lazy = false,
	--   priority = 1000,
	--   opts = {
	--     transparent = true,
	--   },
	--   config = function(_, opts)
	--     require("cyberdream").setup(opts)
	--     vim.cmd.colorscheme("cyberdream")
	--   end,
	-- },
}
