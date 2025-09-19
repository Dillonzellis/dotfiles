return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Direct setup using new vim.lsp.config API for tailwindcss
		vim.lsp.config.tailwindcss = {
			on_attach = require("config.lsp").on_attach,
			capabilities = require("config.lsp").get_capabilities(),
			root_markers = {
				"tailwind.config.mjs",
				"tailwind.config.js",
				"tailwind.config.cjs",
				"tailwind.config.ts",
				"package.json",
			},
			settings = {
				tailwindCSS = {
					experimental = {
						classRegex = {
							{ "cn\\s*\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
							{ "classify\\s*\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
						},
					},
				},
			},
		}

		-- Enable the tailwindcss server
		vim.lsp.enable("tailwindcss")
	end,
}
