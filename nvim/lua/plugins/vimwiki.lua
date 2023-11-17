return {
  "vimwiki/vimwiki",

  config = function()
    -- Any vimwiki specific configuration/setup...

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    -- Unmap the default <leader>ww
    vim.api.nvim_del_keymap("n", "<leader>ww")

    -- Map <leader>ll to Vimwiki command
    keymap.set("n", "<leader>ll", "<cmd>VimwikiIndex<cr>", { desc = "Open Vimwiki" })
  end,
}
