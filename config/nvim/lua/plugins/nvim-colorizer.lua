-- lua/plugins/colorizer.lua
return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {
		filetypes = {
			"*", -- Highlight all files
			-- Specific configurations for different file types
			cmp_docs = { always_update = true }, -- Keep completion menu colors updated
			cmp_menu = { always_update = true }, -- Keep completion menu colors updated
		},
		user_default_options = {
			RGB = true, -- #RGB hex codes
			RRGGBB = true, -- #RRGGBB hex codes
			names = false, -- Disable "Blue" or "red" named colors for better performance
			RRGGBBAA = false, -- #RRGGBBAA hex codes
			AARRGGBB = false, -- 0xAARRGGBB hex codes
			rgb_fn = false, -- CSS rgb() and rgba() functions
			hsl_fn = false, -- CSS hsl() and hsla() functions
			css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
			css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn

			-- The key configuration for Tailwind
			tailwind = "both", -- This enables both "normal" and "lsp" modes
			tailwind_opts = {
				update_names = true, -- Updates cache from LSP results for custom colors
			},

			-- Display mode
			mode = "background", -- "background" | "foreground" | "virtualtext"

			-- Virtual text options (if you prefer virtualtext mode)
			virtualtext = "󰝤",
			virtualtext_inline = false, -- true = before, false = end of line
			virtualtext_mode = "foreground",

			-- Performance option
			always_update = false,
		},
		-- Enable specific buffer types
		buftypes = {
			"*",
			"!prompt",
			"!popup",
		},
	},
}
