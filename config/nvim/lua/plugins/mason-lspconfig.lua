return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { "mason.nvim", "nvim-lspconfig" },
	config = function()
		local lsp_config = require("config.lsp")

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"vtsls",
				"html",
				"cssls",
				"tailwindcss",
				"bashls",
				"jsonls",
			},
			automatic_installation = true,
			handlers = {
				-- Default handler
				function(server_name)
					require("lspconfig")[server_name].setup({
						on_attach = lsp_config.on_attach,
						capabilities = lsp_config.get_capabilities(),
					})
				end,

				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						on_attach = lsp_config.on_attach,
						capabilities = lsp_config.get_capabilities(),
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								diagnostics = { globals = { "vim" } },
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
									checkThirdParty = false,
								},
								telemetry = { enable = false },
							},
						},
					})
				end,

				["vtsls"] = function()
					require("lspconfig").vtsls.setup({
						on_attach = lsp_config.on_attach,
						capabilities = lsp_config.get_capabilities(),
						settings = {
							typescript = {
								inlayHints = {
									parameterNames = { enabled = "literals" },
									parameterTypes = { enabled = true },
									variableTypes = { enabled = false },
									propertyDeclarationTypes = { enabled = true },
									functionLikeReturnTypes = { enabled = true },
									enumMemberValues = { enabled = true },
								},
							},
							javascript = {
								inlayHints = {
									parameterNames = { enabled = "literals" },
									parameterTypes = { enabled = true },
									variableTypes = { enabled = false },
									propertyDeclarationTypes = { enabled = true },
									functionLikeReturnTypes = { enabled = true },
									enumMemberValues = { enabled = true },
								},
							},
						},
					})
				end,

				-- ["tailwindcss"] = function()
				-- 	require("lspconfig").tailwindcss.setup({
				-- 		on_attach = lsp_config.on_attach,
				-- 		capabilities = lsp_config.get_capabilities(),
				-- 		root_dir = function(fname)
				-- 			return require("lspconfig.util").root_pattern(
				-- 				"tailwind.config.mjs",
				-- 				"tailwind.config.js",
				-- 				"tailwind.config.cjs",
				-- 				"tailwind.config.ts",
				-- 				"package.json"
				-- 			)(fname)
				-- 		end,
				-- 		filetypes = {
				-- 			"aspnetcorerazor",
				-- 			"astro",
				-- 			"astro-markdown",
				-- 			"blade",
				-- 			"clojure",
				-- 			"django-html",
				-- 			"htmldjango",
				-- 			"edge",
				-- 			"eelixir",
				-- 			"elixir",
				-- 			"ejs",
				-- 			"erb",
				-- 			"eruby",
				-- 			"gohtml",
				-- 			"gohtmltmpl",
				-- 			"haml",
				-- 			"handlebars",
				-- 			"hbs",
				-- 			"html",
				-- 			"html-eex",
				-- 			"heex",
				-- 			"jade",
				-- 			"leaf",
				-- 			"liquid",
				-- 			"markdown",
				-- 			"mdx",
				-- 			"mustache",
				-- 			"njk",
				-- 			"nunjucks",
				-- 			"php",
				-- 			"razor",
				-- 			"slim",
				-- 			"twig",
				-- 			"css",
				-- 			"less",
				-- 			"postcss",
				-- 			"sass",
				-- 			"scss",
				-- 			"stylus",
				-- 			"sugarss",
				-- 			"javascript",
				-- 			"javascriptreact",
				-- 			"reason",
				-- 			"rescript",
				-- 			"typescript",
				-- 			"typescriptreact",
				-- 			"vue",
				-- 			"svelte",
				-- 			"templ",
				-- 		},
				-- 		init_options = {
				-- 			userLanguages = {
				-- 				eelixir = "html-eex",
				-- 				eruby = "erb",
				-- 				htmlangular = "html",
				-- 				templ = "html",
				-- 			},
				-- 		},
				-- 		settings = {
				-- 			tailwindCSS = {
				-- 				classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
				-- 				includeLanguages = {
				-- 					typescript = "javascript",
				-- 					typescriptreact = "javascript",
				-- 					eelixir = "html-eex",
				-- 					elixir = "html-eex",
				-- 					eruby = "erb",
				-- 					heex = "html-eex",
				-- 					htmlangular = "html",
				-- 					templ = "html",
				-- 				},
				-- 				lint = {
				-- 					cssConflict = "warning",
				-- 					invalidApply = "error",
				-- 					invalidConfigPath = "error",
				-- 					invalidScreen = "error",
				-- 					invalidTailwindDirective = "error",
				-- 					invalidVariant = "error",
				-- 					recommendedVariantOrder = "warning",
				-- 				},
				-- 				validate = true,
				-- 				experimental = {
				-- 					classRegex = {
				-- 						-- Single strings (simpler format that works better)
				-- 						"classify\\(([^)]*)",
				-- 						"cn\\(\\s*classify\\([^)]*\\)",
				-- 						-- String patterns for object properties
				-- 						"(base|sm|md|lg|xl|xxl)\\s*:\\s*[\"']([^\"']*)[\"']",
				-- 						-- Generic object property pattern
				-- 						":\\s*[\"']([^\"']*)[\"']",
				-- 					},
				-- 				},
				-- 			},
				-- 		},
				-- 	})
				-- end,
			},
		})
	end,
}
