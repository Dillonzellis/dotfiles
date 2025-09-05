-- Enhanced Single-File Neovim Configuration with LSP & Diagnostics
-- Based on LazyVim patterns

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Basic Options
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.clipboard = "unnamedplus"
vim.opt.winborder = "rounded"

-- Enhanced options for better LSP experience
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = "menu,menuone,noselect"
vim.o.pumheight = 10

-- Commands
vim.cmd("hi statusline guibg=NONE")

-- Leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Enhanced Diagnostics Configuration (like LazyVim)
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- LSP Keymaps (similar to LazyVim)
local function setup_lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- Navigation
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, opts)

  -- Code actions
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>cc', vim.lsp.codelens.run, opts)
  vim.keymap.set('n', '<leader>cC', vim.lsp.codelens.refresh, opts)
  vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)

  -- Formatting
  vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
    vim.lsp.buf.format({ async = true })
  end, opts)

  -- Diagnostics
  vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']e', function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, opts)
  vim.keymap.set('n', '[e', function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, opts)
  vim.keymap.set('n', ']w', function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
  end, opts)
  vim.keymap.set('n', '[w', function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
  end, opts)
end

-- LSP Capabilities (for better completion support)
local function get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- Add completion capabilities if you have a completion plugin
  -- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  -- Folding capabilities for nvim-ufo
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }

  return capabilities
end

-- LSP on_attach function (like LazyVim)
local function on_attach(client, bufnr)
  setup_lsp_keymaps(bufnr)

  -- Enable inlay hints if supported
  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  -- Highlight symbol under cursor
  if client.supports_method("textDocument/documentHighlight") then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Auto-format on save (optional)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
      end,
    })
  end
end

-- Setup plugins with lazy.nvim
require("lazy").setup({
  {
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
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
  },
{
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "mason.nvim", "nvim-lspconfig" },
  opts = {
    ensure_installed = {
      "lua_ls", "vtsls", "html", "cssls", "bashls", "jsonls"  -- Changed ts_ls to vtsls
    },
    automatic_installation = true,
    handlers = {
      -- Default handler
      function(server_name)
        require("lspconfig")[server_name].setup({
          on_attach = on_attach,
          capabilities = get_capabilities(),
        })
      end,
      ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup({
          on_attach = on_attach,
          capabilities = get_capabilities(),
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              diagnostics = { globals = { 'vim' } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
              },
              telemetry = { enable = false },
            }
          }
        })
      end,
      ["vtsls"] = function()
        require("lspconfig").vtsls.setup({
          on_attach = on_attach,
          capabilities = get_capabilities(),
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              }
            },
          }
        })
      end,
    },
  },
},
}, {
  ui = { border = "rounded" },
})

-- Global LSP keymaps (not buffer-specific)
vim.keymap.set('n', '<C-s>', ':update<CR>')
vim.keymap.set('n', '<leader>lf', function()
  vim.lsp.buf.format({ async = true })
end)

-- Enhanced diagnostic keymaps
vim.keymap.set('n', '<leader>xl', '<cmd>lopen<cr>', { desc = "Location List" })
vim.keymap.set('n', '<leader>xq', '<cmd>copen<cr>', { desc = "Quickfix List" })

-- LSP workspace commands
vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = "Add Workspace Folder" })
vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = "Remove Workspace Folder" })
vim.keymap.set('n', '<leader>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "List Workspace Folders" })

-- Auto-commands for better LSP experience
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

      -- Show line diagnostics automatically in hover window
      vim.api.nvim_create_autocmd("CursorHold", {
        buffer = ev.buf,
        callback = function()
          local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
          }
          vim.diagnostic.open_float(nil, opts)
        end
      })
    end
  end,
})

-- Customize LSP floating windows
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

-- Status line integration (simple)
vim.o.statusline = "%f %m%r%h%w [%{&ff}] [%{&ft}] %{v:lua.LspStatus()} %= %l,%c %P"

function LspStatus()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end

  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end

  return "[LSP: " .. table.concat(names, ",") .. "]"
end
