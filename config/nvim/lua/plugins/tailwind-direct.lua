return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Direct setup bypassing mason-lspconfig for tailwindcss only
		require("lspconfig").tailwindcss.setup({
			on_attach = require("config.lsp").on_attach,
			capabilities = require("config.lsp").get_capabilities(),
			root_dir = function(fname)
				return require("lspconfig.util").root_pattern(
					"tailwind.config.mjs",
					"tailwind.config.js",
					"tailwind.config.cjs",
					"tailwind.config.ts",
					"package.json"
				)(fname)
			end,
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
		})
	end,
}
