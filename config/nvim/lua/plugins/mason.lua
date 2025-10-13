return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  opts = {
    ensure_installed = {
      "lua-language-server",
      "vtsls",
      "html-lsp",
      "css-lsp",
      "bash-language-server",
      "json-lsp",
      "stylua",
      "prettier",
      "prettierd",
      "shfmt",
      "eslint_d",
      "shellcheck",
      "eslint-lsp",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    local function ensure_installed()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end
    if mr.refresh then
      mr.refresh(ensure_installed)
    else
      ensure_installed()
    end
  end,
}
