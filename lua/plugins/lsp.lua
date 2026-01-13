-- [[ LSP ]]
return {
  -- Configures LuaLS to support auto-completion and type checking
  -- while editing your Neovim configuration.
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    cmd = "LazyDev",
  },

  -- yaml/json schema support
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  -- Mason Installer
  { import = "config.mason" },

  {
    "j-hui/fidget.nvim", -- display the LSP progress
    opts = {},
  },

  -- Formatter
  { import = "config.conform" },

  -- Main LSP config
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      require("config.lsp").setup()
    end,
  },

  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
  },
}
