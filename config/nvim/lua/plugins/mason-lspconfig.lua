return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { "mason.nvim", "nvim-lspconfig" },
	config = function()
		local lsp_config = require("config.lsp")

		-- Install LSP servers automatically
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
		})

		-- Configure each server using the new vim.lsp.config API

		-- Lua Language Server
		vim.lsp.config.lua_ls = {
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
		}

		-- TypeScript/JavaScript Language Server
		vim.lsp.config.vtsls = {
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
		}

		-- Other servers with default configuration
		local default_servers = { "html", "cssls", "tailwindcss", "bashls", "jsonls" }
		for _, server in ipairs(default_servers) do
			vim.lsp.config[server] = {
				on_attach = lsp_config.on_attach,
				capabilities = lsp_config.get_capabilities(),
			}
		end

		-- Enable all configured servers
		vim.lsp.enable({
			"lua_ls",
			"vtsls",
			"html",
			"cssls",
			"tailwindcss",
			"bashls",
			"jsonls",
		})

		-- Uncomment and configure Tailwind CSS if needed
		-- vim.lsp.config.tailwindcss = {
		-- 	on_attach = lsp_config.on_attach,
		-- 	capabilities = lsp_config.get_capabilities(),
		-- 	root_markers = {
		-- 		"tailwind.config.mjs",
		-- 		"tailwind.config.js",
		-- 		"tailwind.config.cjs",
		-- 		"tailwind.config.ts",
		-- 		"package.json"
		-- 	},
		-- 	filetypes = {
		-- 		"aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure",
		-- 		"django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs",
		-- 		"erb", "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs",
		-- 		"html", "html-eex", "heex", "jade", "leaf", "liquid", "markdown",
		-- 		"mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig",
		-- 		"css", "less", "postcss", "sass", "scss", "stylus", "sugarss",
		-- 		"javascript", "javascriptreact", "reason", "rescript", "typescript",
		-- 		"typescriptreact", "vue", "svelte", "templ",
		-- 	},
		-- 	settings = {
		-- 		tailwindCSS = {
		-- 			classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
		-- 			includeLanguages = {
		-- 				typescript = "javascript",
		-- 				typescriptreact = "javascript",
		-- 				eelixir = "html-eex",
		-- 				elixir = "html-eex",
		-- 				eruby = "erb",
		-- 				heex = "html-eex",
		-- 				htmlangular = "html",
		-- 				templ = "html",
		-- 			},
		-- 			lint = {
		-- 				cssConflict = "warning",
		-- 				invalidApply = "error",
		-- 				invalidConfigPath = "error",
		-- 				invalidScreen = "error",
		-- 				invalidTailwindDirective = "error",
		-- 				invalidVariant = "error",
		-- 				recommendedVariantOrder = "warning",
		-- 			},
		-- 			validate = true,
		-- 			experimental = {
		-- 				classRegex = {
		-- 					"classify\\(([^)]*)",
		-- 					"cn\\(\\s*classify\\([^)]*\\)",
		-- 					"(base|sm|md|lg|xl|xxl)\\s*:\\s*[\"']([^\"']*)[\"']",
		-- 					":\\s*[\"']([^\"']*)[\"']",
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		-- }
	end,
}
