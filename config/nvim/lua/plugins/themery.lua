return {
	"zaldih/themery.nvim",
	lazy = true,
	enabled = false,
	config = function()
		require("themery").setup({
			themes = {
				-- Your installed themes
				{ name = "tokyonight", colorscheme = "tokyonight" },
				{ name = "gruvbox", colorscheme = "gruvbox" },
				{ name = "synthwave84", colorscheme = "synthwave84" },
				{ name = "kanagawa", colorscheme = "kanagawa" },
				{ name = "carbonfox", colorscheme = "carbonfox" },
				{ name = "everforest", colorscheme = "everforest" },
				{ name = "cyberdream", colorscheme = "cyberdream" },
				{ name = "tokyodark", colorscheme = "tokyodark" },
				-- Default themes
				{ name = "default", colorscheme = "default" },
				{ name = "darkblue", colorscheme = "darkblue" },
				{ name = "delek", colorscheme = "delek" },
				{ name = "desert", colorscheme = "desert" },
				{ name = "elflord", colorscheme = "elflord" },
				{ name = "evening", colorscheme = "evening" },
				{ name = "koehler", colorscheme = "koehler" },
				{ name = "morning", colorscheme = "morning" },
				{ name = "murphy", colorscheme = "murphy" },
				{ name = "pablo", colorscheme = "pablo" },
				{ name = "peachpuff", colorscheme = "peachpuff" },
				{ name = "ron", colorscheme = "ron" },
				{ name = "shine", colorscheme = "shine" },
				{ name = "slate", colorscheme = "slate" },
				{ name = "torte", colorscheme = "torte" },
				{ name = "zellner", colorscheme = "zellner" },
			},
		})
	end,
}
