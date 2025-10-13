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
				"eslint", -- Added ESLint LSP
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

		-- ⭐ ESLint Language Server configuration
  vim.lsp.config.eslint = {
	  on_attach = lsp_config.on_attach, -- This already handles ESLint fixes via code actions
	  capabilities = lsp_config.get_capabilities(),
	  settings = {
		  codeAction = {
			  disableRuleComment = {
				  enable = true,
				  location = "separateLine",
			  },
			  showDocumentation = {
				  enable = true,
			  },
		  },
		  codeActionOnSave = {
			  enable = true,
			  mode = "all",
		  },
		  format = true,
		  nodePath = "",
		  onIgnoredFiles = "off",
		  packageManager = "npm",
		  quiet = false,
		  rulesCustomizations = {},
		  run = "onType",
		  useESLintClass = false,
		  validate = "on",
		  workingDirectory = {
			  mode = "auto",
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
	  "eslint",
  })  end,
}
