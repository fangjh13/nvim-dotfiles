local M = {}

function M.setup(servers, server_options)
  local lspconfig = require "lspconfig"
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

  require("mason-tool-installer").setup {
    auto_update = false,
    run_on_start = true,
  }

  require("mason-lspconfig").setup {
    -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
    -- This setting has no relation with the `automatic_installation` setting.
    ---@type string[]
    ensure_installed = vim.tbl_keys(servers),

    -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
    -- This setting has no relation with the `ensure_installed` setting.
    -- Can either be:
    --   - false: Servers are not automatically installed.
    --   - true: All servers set up via lspconfig are automatically installed.
    --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
    --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
    ---@type boolean
    automatic_installation = false,
  }

  -- Package installation folder
  local install_root_dir = vim.fn.stdpath "data" .. "/mason"

  -- Now we can register a handler that will be called for all installed servers.
  require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler
      local opts = vim.tbl_deep_extend("force", server_options, servers[server_name] or {})
      lspconfig[server_name].setup(opts)
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    ["pyright"] = function()
      local opts = vim.tbl_deep_extend("force", server_options, servers["pyright"] or {})
      lspconfig.pyright.setup(opts)
    end,
  }
end

return M
