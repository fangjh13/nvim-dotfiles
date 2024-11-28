return {
  "folke/lazydev.nvim",
  event = "VeryLazy",
  ft = "lua", -- only load on lua files
  opts = {
    library = {
      "lazy.nvim",
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
}
