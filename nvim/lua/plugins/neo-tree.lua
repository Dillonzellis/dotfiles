return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    -- disable the keymap to grep files
    { "<leader>be", false },
    { "<leader>e", false },
    { "<leader>E", false },
    { "<leader>fe", false },
    { "<leader>fE", false },
    { "<leader>ge", false },
    -- change a keymap
    { "<C-m>", desc = "Explorer NeoTree (root dir)", remap = true },
    -- add a keymap to browse plugin files
  },
}