-- [[ LSP ]]
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "cmp-nvim-lsp",
      "vim-illuminate",
      "nvimtools/none-ls.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "jayp0521/mason-null-ls.nvim",
      "RRethy/vim-illuminate",
      "b0o/schemastore.nvim",
      {
        "j-hui/fidget.nvim", -- display the LSP progress
        opts = {},
      },
    },
    config = function()
      require("config.lsp").setup()
    end,
  },
}
