-- [[ LSP ]]
return {
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

  -- Linter
  { import = "config.nvim_lint" },

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

  {
    -- Configures LuaLS to support auto-completion and type checking
    -- while editing your Neovim configuration.
    "folke/lazydev.nvim",
    event = "VeryLazy",
    ft = "lua", -- only load on lua files
    cmd = "LazyDev",
    opts = {
      library = {
        -- Any plugin you wanna have LSP autocompletion for, add it here.
        -- in 'path', write the name of the plugin directory, vim.fn.stdpath "data" .. "/lazy"
        -- in 'mods', write the word you use to require the module.
        -- in 'words' write words that trigger loading a lazydev path (optionally).
        { path = "lazy.nvim", mods = { "lazy" } },
        { path = "nvim-cmp", mods = { "cmp" } },
        { path = "nvim-treesitter", mods = { "nvim-treesitter" } },
        { path = "telescope.nvim", mods = { "telescope" } },
        { path = "nvim-lint.nvim", word = { "lint" } },
        -- Only load the lazyvim library when the `LazyVim` global is found
        { path = "LazyVim", words = { "LazyVim" } },

        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
    dependencies = {
      { "Bilal2453/luvit-meta", lazy = true }, -- `vim.uv` typings
    },
  },
}
