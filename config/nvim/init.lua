require("config.lazy")

-- Load configuration modules
require("config.keymaps")
require("config.options")
require("config.autocmds")

-- Setup LSP configuration
require("config.lsp").setup()


