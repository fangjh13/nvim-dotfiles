local M = {}

function M.setup(servers, server_options)
  local lspconfig = vim.lsp.config

  for name, _ in pairs(servers) do
    local opts = vim.tbl_deep_extend("force", server_options, servers[name] or {})
    if name == "nixd" then
      -- NOTE: Mason not support nixd, setup manually
      -- nixd install with nixos system not need install
      servers["nixd"] = nil
      lspconfig("nixd", opts)
      vim.lsp.enable "nixd"
    elseif name == "rust_analyzer" then
      -- NOTE: do not set init_options
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#rust_analyzer
      opts.init_options = nil
      lspconfig("rust_analyzer", opts)
    elseif name == "clangd" and vim.loop.os_uname().machine == "aarch64" then
      -- NOTE: Mason not support arm clangd, setup manually
      servers["clangd"] = nil
      lspconfig("clangd", opts)
      vim.lsp.enable "clangd"
    elseif name == "lua_ls" then
      lspconfig("lua_ls", opts)
      -- setup lazydev
      local lazy_opts = { ---@type lazydev.Config
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "lazy.nvim", words = { "LazyVim" } },
          { path = "snacks.nvim", words = { "Snacks" } },
        },
      }
      require("lazydev").setup(lazy_opts)
    else
      lspconfig(name, opts)
    end
  end

  require("mason-lspconfig").setup {
    -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
    ---@type string[]
    ensure_installed = vim.tbl_keys(servers),

    ---@type boolean | string[] | { exclude: string[] }
    automatic_enable = true,
  }
end

return M
