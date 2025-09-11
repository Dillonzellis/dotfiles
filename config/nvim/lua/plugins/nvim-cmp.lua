return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Core completion sources
		"hrsh7th/cmp-nvim-lsp", -- LSP completion
		"hrsh7th/cmp-buffer", -- Buffer completion
		"hrsh7th/cmp-path", -- Path completion
		"hrsh7th/cmp-cmdline", -- Command line completion
		-- Snippet engine (required for nvim-cmp)
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp", -- Optional for better regex support
			dependencies = {
				"rafamadriz/friendly-snippets", -- Pre-built snippets
			},
		},
		"saadparwaiz1/cmp_luasnip", -- LuaSnip completion source
		-- Tailwind CSS colorizer for visual color previews
		{
			"roobert/tailwindcss-colorizer-cmp.nvim",
			config = true, -- This calls require("tailwindcss-colorizer-cmp").setup({})
		},
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		-- Load friendly-snippets
		require("luasnip.loaders.from_vscode").lazy_load()
		-- Helper function for super-tab behavior
		local has_words_before = function()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			-- Completion window appearance
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			-- Key mappings
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept with Ctrl+y
				["<C-p>"] = cmp.mapping.select_prev_item(), -- Scroll up with Ctrl+p
				["<C-n>"] = cmp.mapping.select_next_item(), -- Scroll down with Ctrl+n
				["<C-e>"] = cmp.mapping.abort(),
			}),
			-- Completion sources (order matters for priority)
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
				{ name = "path" },
			}),
			-- Formatting with Tailwind colorizer integration
			formatting = {
				format = function(entry, vim_item)
					-- Kind icons
					local kind_icons = {
						Text = "",
						Method = "󰆧",
						Function = "󰊕",
						Constructor = "",
						Field = "󰇽",
						Variable = "󰂡",
						Class = "󰠱",
						Interface = "",
						Module = "",
						Property = "󰜢",
						Unit = "",
						Value = "󰎠",
						Enum = "",
						Keyword = "󰌋",
						Snippet = "",
						Color = "󰏘",
						File = "󰈙",
						Reference = "",
						Folder = "󰉋",
						EnumMember = "",
						Constant = "󰏿",
						Struct = "",
						Event = "",
						Operator = "󰆕",
						TypeParameter = "󰅲",
					}
					-- This concatenates the icons with the name of the item kind
					vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
					-- Source names
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						luasnip = "[Snippet]",
						buffer = "[Buffer]",
						path = "[Path]",
					})[entry.source.name]

					-- Apply Tailwind colorizer formatting
					return require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
				end,
			},
			-- Experimental features
			experimental = {
				ghost_text = true, -- Show ghost text for inline completion
			},
		})
		-- Command line completion
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})
	end,
}
