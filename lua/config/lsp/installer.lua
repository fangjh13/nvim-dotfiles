local M = {}

function M.setup(servers, server_options)
  local lspconfig = require "lspconfig"
  local icons = require "config.icons"

  require("mason").setup {
    ui = {
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
    -- vim.tbl_deep_extend("force", servers, "ruff")
    ensure_installed = vim.tbl_keys(servers),
  }

  -- Package installation folder
  local install_root_dir = vim.fn.stdpath "data" .. "/mason"

  require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name)
      local opts = vim.tbl_deep_extend("force", server_options, servers[server_name] or {})
      lspconfig[server_name].setup(opts)
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    ["lua_ls"] = function()
      local opts = vim.tbl_deep_extend("force", server_options, servers["lua_ls"] or {})
      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      require("neodev").setup {}
      lspconfig.lua_ls.setup(opts)
    end,
    ["pyright"] = function()
      local opts = vim.tbl_deep_extend("force", server_options, servers["pyright"] or {})
      lspconfig.pyright.setup(opts)
    end,
    -- ["rust_analyzer"] = function()
    --   local opts = vim.tbl_deep_extend("force", server_options, servers["rust_analyzer"] or {})
    --
    --   -- DAP settings - https://github.com/simrat39/rust-tools.nvim#a-better-debugging-experience
    --   local extension_path = install_root_dir .. "/packages/codelldb/extension/"
    --   local codelldb_path = extension_path .. "adapter/codelldb"
    --   local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
    --   local ih = require "inlay-hints"
    --   require("rust-tools").setup {
    --     tools = {
    --       -- executor = require("rust-tools/executors").toggleterm,
    --       hover_actions = { border = "solid" },
    --       on_initialized = function()
    --         vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
    --           pattern = { "*.rs" },
    --           callback = function()
    --             vim.lsp.codelens.refresh()
    --           end,
    --         })
    --         ih.set_all()
    --       end,
    --       inlay_hints = {
    --         auto = false,
    --       },
    --     },
    --     server = opts,
    --     dap = {
    --       adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    --     },
    --   }
    -- end,
    -- ["tsserver"] = function()
    --   local opts = vim.tbl_deep_extend("force", server_options, servers["tsserver"] or {})
    --   require("typescript").setup {
    --     disable_commands = false,
    --     debug = false,
    --     server = opts,
    --   }
    -- end,
  }
end

return M
