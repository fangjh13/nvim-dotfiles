local M = {}

local servers = require "config.lsp.servers"
local servers_hook = require "config.lsp.servers_hook"

function M.on_attach(client, bufnr)
  local caps = client.server_capabilities

  local function buf_set_option(option, value)
    vim.api.nvim_set_option_value(option, value, { buf = bufnr })
  end

  -- Enable completion triggered by <C-X><C-O>
  -- See `:help omnifunc` and `:help ins-completion` for more information.
  if caps.completionProvider then
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
  end

  -- Enable Inlay Hints or use `:LspInlayHitsToggle` command enable
  -- if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
  --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  -- end

  -- Use LSP as the handler for formatexpr.
  -- See `:help formatexpr` for more information.
  if caps.documentFormattingProvider then
    buf_set_option("formatexpr", "v:lua.vim.lsp.formatexpr()")
  end

  -- Configure key mappings
  require("config.lsp.keymaps").setup(client, bufnr)

  -- Configure highlighting
  require("config.lsp.highlighter").setup(client, bufnr)

  -- Configure formatting
  require("config.lsp.null-ls.formatters").setup(client, bufnr)

  -- tagfunc
  if caps.definitionProvider then
    buf_set_option("tagfunc", "v:lua.vim.lsp.tagfunc")
  end

  -- display diagnostic in floating window on CursorHold
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "CursorMoved", "InsertEnter" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "cursor",
      }
      vim.diagnostic.open_float(nil, opts)
    end,
    desc = "Display diagnostic window on CursorHold",
  })

  -- additional config
  for name, callback in pairs(servers_hook) do
    if name == client.name then
      callback(client, bufnr)
    end
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}
-- NOTE: https://github.com/neovim/neovim/issues/23291
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
-- for nvim-cmp
M.capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- Setup LSP handlers
require("config.lsp.handlers").setup()

local opts = {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  init_options = {
    usePlaceholders = true,
  },
}

function M.setup()
  vim.lsp.set_log_level "error"

  -- null-ls
  require("config.lsp.null-ls").setup(opts)

  -- Install dependencies and set up servers via lspconfig
  require("config.lsp.installer").setup(servers, opts)
end

local diagnostics_active = true

function M.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

return M
