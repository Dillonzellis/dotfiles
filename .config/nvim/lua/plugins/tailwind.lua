return {
  -- Mason configuration to ensure tailwindcss LSP is installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tailwindcss-language-server" })
    end,
  },

  -- LSP configuration for Tailwind CSS
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Configure tailwindcss server
      opts.servers.tailwindcss = {
        -- Set root directory detection
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern(
            "tailwind.config.js",
            "tailwind.config.cjs",
            "tailwind.config.mjs",
            "tailwind.config.ts",
            "package.json"
          )(fname)
        end,

        -- File types to attach to
        filetypes = {
          "aspnetcorerazor",
          "astro",
          "astro-markdown",
          "blade",
          "clojure",
          "django-html",
          "htmldjango",
          "edge",
          "eelixir",
          "elixir",
          "ejs",
          "erb",
          "eruby",
          "gohtml",
          "gohtmltmpl",
          "haml",
          "handlebars",
          "hbs",
          "html",
          "html-eex",
          "heex",
          "jade",
          "leaf",
          "liquid",
          "markdown",
          "mdx",
          "mustache",
          "njk",
          "nunjucks",
          "php",
          "razor",
          "slim",
          "twig",
          "css",
          "less",
          "postcss",
          "sass",
          "scss",
          "stylus",
          "sugarss",
          "javascript",
          "javascriptreact",
          "reason",
          "rescript",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
          "templ",
        },

        -- Initialize options
        init_options = {
          userLanguages = {
            eelixir = "html-eex",
            eruby = "erb",
            htmlangular = "html",
            templ = "html",
          },
        },

        -- Settings with custom classRegex patterns
        settings = {
          tailwindCSS = {
            -- Custom class attributes
            classAttributes = { "class", "className", "class:list", "classList", "ngClass" },

            -- Include additional languages
            includeLanguages = {
              typescript = "javascript",
              typescriptreact = "javascript",
              eelixir = "html-eex",
              elixir = "html-eex",
              eruby = "erb",
              heex = "html-eex",
              htmlangular = "html",
              templ = "html",
            },

            -- Lint settings
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidConfigPath = "error",
              invalidScreen = "error",
              invalidTailwindDirective = "error",
              invalidVariant = "error",
              recommendedVariantOrder = "warning",
            },

            -- Validation
            validate = true,

            -- EXPERIMENTAL: Custom class regex patterns for your utility functions
            experimental = {
              classRegex = {
                -- Standard className patterns
                { "className\\s*[:=]\\s*[\"'`]([^\"'`]*)[\"'`]" },
                { "class\\s*[:=]\\s*[\"'`]([^\"'`]*)[\"'`]" },

                -- Template literals with expressions
                { "className\\s*[:=]\\s*`([^`]*)`" },
                { "class\\s*[:=]\\s*`([^`]*)`" },

                -- cn() and classify() function calls with nested patterns
                { "cn\\s*\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
                { "classify\\s*\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },

                -- Object property values in utility functions
                { ":\\s*[\"'`]([^\"'`]*)[\"'`]" },

                -- Classes in template strings with interpolation
                { "`([^`]*)`", "[\"'`]([^\"'`]*)[\"'`]" },

                -- Generic string patterns for class-like properties
                { "(base|md|lg|xl|xxl|alignment)\\s*:\\s*[\"'`]([^\"'`]*)[\"'`]" },

                -- Catch classes in conditional objects
                { "\\{[^}]*[\"'`]([^\"'`]*)[\"'`]\\s*:" },

                -- Multi-line template literals
                { "className\\s*[:=]\\s*`([\\s\\S]*?)`" },
                { "class\\s*[:=]\\s*`([\\s\\S]*?)`" },

                -- Additional patterns for your specific use case
                { "getTitleClasses\\s*\\([^)]*\\)", "[\"'`]([^\"'`]*)[\"'`]" },
                { "getContentClasses\\s*\\([^)]*\\)", "[\"'`]([^\"'`]*)[\"'`]" },
                { "getWrapperClasses\\s*\\([^)]*\\)", "[\"'`]([^\"'`]*)[\"'`]" },
                { "dynamicChildClasses", "[\"'`]([^\"'`]*)[\"'`]" },
                { "h3Classes", "[\"'`]([^\"'`]*)[\"'`]" },
                { "textBaseClasses", "[\"'`]([^\"'`]*)[\"'`]" },
                { "paragraphClasses", "[\"'`]([^\"'`]*)[\"'`]" },
                { "linkClasses", "[\"'`]([^\"'`]*)[\"'`]" },
                { "strongClasses", "[\"'`]([^\"'`]*)[\"'`]" },
                { "emClasses", "[\"'`]([^\"'`]*)[\"'`]" },
              },
            },
          },
        },
      }

      return opts
    end,
  },

  -- Optional: CMP integration for Tailwind CSS color previews
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
    },
    opts = function(_, opts)
      -- original LazyVim kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
}
