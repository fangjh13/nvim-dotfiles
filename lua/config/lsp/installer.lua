local M = {}

function M.setup(servers, server_options)
  local lspconfig = vim.lsp.config
  local icons = require "config.icons"

  require("mason").setup {
    ui = {
      border = "rounded",
      icons = {
        package_installed = icons.lsp.server_installed,
        package_pending = icons.lsp.server_pending,
        package_uninstalled = icons.lsp.server_uninstalled,
      },
    },
  }
  require("mason-null-ls").setup {
    automatic_installation = true,
    automatic_setup = true,
  }

  -- require("mason-tool-installer").setup {
  --   auto_update = false,
  --   run_on_start = true,
  -- }

  for name, _ in pairs(servers) do
    local opts = vim.tbl_deep_extend("force", server_options, servers[name] or {})
    if name == "nixd" then
      lspconfig("nixd", opts)
      -- NOTE: Mason not support nixd, setup manually
      -- nixd install with nixos system not need install
      servers["nixd"] = nil
    elseif name == "rust_analyzer" then
      -- NOTE: do not set init_options
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#rust_analyzer
      opts.init_options = nil
      lspconfig("rust_analyzer", opts)
    else
      lspconfig(name, opts)
    end
  end

  require("mason-lspconfig").setup {

    -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
    ---@type string[]
    ensure_installed = vim.tbl_keys(servers),

    -- Whether installed servers should automatically be enabled via `:h vim.lsp.enable()`.
    --
    -- To exclude certain servers from being automatically enabled:
    -- ```lua
    --   automatic_enable = {
    --     exclude = { "rust_analyzer", "ts_ls" }
    --   }
    -- ```
    --
    -- To only enable certain servers to be automatically enabled:
    -- ```lua
    --   automatic_enable = {
    --     "lua_ls",
    --     "vimls"
    --   }
    -- ```
    ---@type boolean | string[] | { exclude: string[] }
    automatic_enable = true,
  }
end

return M
