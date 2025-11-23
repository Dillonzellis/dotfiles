require("config.lazy")
require("config.keymaps")
require("config.options")
require("config.autocmds")
require("config.lsp").setup()

vim.o.showmode = false

_G.j_mode = function()
  local m = vim.api.nvim_get_mode().mode
  local map = {
    n = "通常", -- NORMAL
    no = "通常", -- OP-PENDING (mapped)
    i = "挿入", -- INSERT
    ic = "挿入", -- INSERT (completion)
    v = "ビジュアル", -- VISUAL
    V = "行ビジュアル", -- VISUAL LINE
    ["\22"] = "矩形", -- VISUAL BLOCK (CTRL-V)
    c = "コマンド", -- COMMAND-LINE
    R = "置換", -- REPLACE
    Rx = "仮置換", -- VIRTUAL REPLACE
    s = "選択", -- SELECT
    S = "行選択", -- SELECT LINE
    t = "ターミナル", -- TERMINAL
  }

  return map[m] or m
end

vim.o.statusline = "%{%v:lua.j_mode()%} %=%m %f %l:%c %p%%"
