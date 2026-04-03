return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  lazy = false,
}
