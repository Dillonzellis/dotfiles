return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      transparent_mode = true,
    },
  },
  {
    "lunarvim/synthwave84.nvim",
    config = function()
      require("synthwave84").setup({
        glow = {
          error_msg = true,
          type2 = true,
          func = true,
          keyword = true,
          operator = false,
          buffer_current_target = true,
          buffer_visible_target = true,
          buffer_inactive_target = true,
        },
      })
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true, -- Enable transparent background
          terminal_colors = true, -- Set terminal colors
          dim_inactive = false, -- Non focused panes set to alternative background
          module_default = true, -- Default enable value for modules
        },
      })
    end,
  },
  {
    "neanias/everforest-nvim",
  },
  {
    "rebelot/kanagawa.nvim",
  },
  {
    "thesimonho/kanagawa-paper.nvim",
    -- lazy = false,
    -- priority = 1000,
    opts = {},
  },
  {
    "mistweaverco/retro-theme.nvim",
    opts = {
      italic_comments = true,
      disable_cache = false,
      hot_reload = false,
    },
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "carbonfox",
    },
  },
}
