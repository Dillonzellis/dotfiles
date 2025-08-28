return {
  {
    "echasnovski/mini.map",
    version = false,
    config = function()
      require("mini.map").setup({
        -- Optional configuration can go here
        -- Using default values if omitted
        symbols = {
          -- Encode symbols for whole line (default uses 3×2 grid)
          encode = nil,
          -- Scrollbar parts
          scroll_line = "█",
          scroll_view = "┃",
          -- Integrations
          integrations = nil,
        },
        -- Window options
        window = {
          -- Side to stick ('left' or 'right')
          side = "right",
          -- Window width
          width = 10,
          -- Window transparency (0 to 100)
          winblend = 25,
          -- Changed to true to show map on startup
          show_on_startup = true,
        },
      })

      -- Ensure minimap opens after startup is complete
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(function()
            require("mini.map").open()
          end, 100) -- Small delay to ensure everything is loaded
        end,
      })
    end,
    -- Lazy load on keys or commands
    keys = {
      { "<leader>mm", "<cmd>lua MiniMap.toggle()<cr>", desc = "Toggle Mini Map" },
      { "<leader>mf", "<cmd>lua MiniMap.toggle_focus()<cr>", desc = "Toggle Mini Map Focus" },
    },
  },
}
