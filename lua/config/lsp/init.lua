local M = {}

local servers = require "config.lsp.servers"
local servers_hook = require "config.lsp.servers_hook"

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

-- for nvim-cmp
M.capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- config LSP diagnostic
require("config.lsp.diagnostic").setup()

-- On attach function
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

  -- tagfunc
  if caps.definitionProvider then
    buf_set_option("tagfunc", "v:lua.vim.lsp.tagfunc")
  end

  -- Configure key mappings
  require("config.lsp.keymaps").setup(client, bufnr)

  -- Configure folds
  require("config.lsp.folds").setup(client, bufnr)

  -- Configure Code Lens
  require("config.lsp.code_lens").setup(client, bufnr)

  -- Configure formatting
  require("config.lsp.format").setup(client, bufnr)

  -- register diagnostic cursor autocmd
  require("config.lsp.diagnostic").autocmd(client, bufnr)

  -- additional config
  for name, callback in pairs(servers_hook) do
    if name == client.name then
      callback(client, bufnr)
    end
  end
end

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

-- Main function
function M.setup()
  vim.lsp.set_log_level "error"

  -- Install dependencies and set up servers via lspconfig
  require("config.lsp.config").setup(servers, opts)
end

return M
