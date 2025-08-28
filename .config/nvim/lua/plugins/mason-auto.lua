return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- You can use "ensure_installed" to automatically install with Mason
        -- Formatters
        "stylua", -- Lua formatter
        "shfmt", -- Shell formatter
        "prettier", -- JavaScript/TypeScript formatter

        -- Linters
        "eslint_d", -- JavaScript/TypeScript linter
        "shellcheck", -- Shell linter
      },
      -- Whether to run :MasonUpdate when index changes
      auto_update = true,
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- List of LSP servers to automatically install
      ensure_installed = {
        "lua_ls", -- Lua
        "ts_ls",
        "html", -- HTML
        "cssls", -- CSS
        "jsonls", -- JSON
        "yamlls", -- YAML
        "bashls", -- Bash
        -- Add any other LSP servers you need
      },
      -- Auto-install configured servers (with lspconfig)
      automatic_installation = true,
    },
  },
  -- Optional: Configure specific LSP server settings
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       lua_ls = {
  --         settings = {
  --           Lua = {
  --             diagnostics = {
  --               globals = { "vim" },
  --             },
  --             workspace = {
  --               checkThirdParty = false,
  --             },
  --             telemetry = {
  --               enable = false,
  --             },
  --           },
  --         },
  --       },
  --       -- Add specific settings for other LSP servers as needed
  --     },
  --   },
  -- },
}
