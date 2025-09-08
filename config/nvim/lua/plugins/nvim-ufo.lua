return {
  "kevinhwang91/nvim-ufo",
  enabled = true,  -- Enable to test
  dependencies = "kevinhwang91/promise-async",
  event = "BufReadPost", -- Load after buffer is read
  config = function()
    -- Required fold settings for nvim-ufo
    vim.o.foldcolumn = '1' -- Show fold column
    vim.o.foldlevel = 99   -- High value = don't auto-fold anything
    vim.o.foldlevelstart = 99 -- Start with all folds open
    vim.o.foldenable = true
    
    -- Set key mappings
    vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
    vim.keymap.set("n", "zK", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = "Peek Fold" })
    
    -- Set up ufo
    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        return { "lsp", "indent" }
      end,
    })
  end,
}
