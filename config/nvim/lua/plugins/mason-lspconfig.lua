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
        "jsonls"
      },
      automatic_installation = true,
      handlers = {
        -- Default handler
        function(server_name)
          require("lspconfig")[server_name].setup({
            on_attach = lsp_config.on_attach,      -- Fixed: use lsp_config module
            capabilities = lsp_config.get_capabilities(), -- Fixed: use lsp_config module
          })
        end,
        
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            on_attach = lsp_config.on_attach,
            capabilities = lsp_config.get_capabilities(),
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false
                },
                telemetry = { enable = false },
              }
            }
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
                }
              },
              javascript = {
                inlayHints = {
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = true },
                  variableTypes = { enabled = false },
                  propertyDeclarationTypes = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  enumMemberValues = { enabled = true },
                }
              }
            }
          })
        end,

        ["tailwindcss"] = function()
          require("lspconfig").tailwindcss.setup({
            on_attach = lsp_config.on_attach,
            capabilities = lsp_config.get_capabilities(),
            settings = {
              tailwindCSS = {
                classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
                lint = {
                  cssConflict = "warning",
                  invalidApply = "error",
                  invalidConfigPath = "error",
                  invalidScreen = "error",
                  invalidTailwindDirective = "error",
                  invalidVariant = "error",
                  recommendedVariantOrder = "warning"
                },
                validate = true
              }
            }
          })
        end,
      },
    })
  end,
}
