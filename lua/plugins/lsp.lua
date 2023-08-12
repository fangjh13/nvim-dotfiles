-- [[ LSP ]]
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "cmp-nvim-lsp",
    "vim-illuminate",
    "null-ls.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "jayp0521/mason-null-ls.nvim",
    "folke/neodev.nvim",
    "RRethy/vim-illuminate",
    "jose-elias-alvarez/null-ls.nvim",
    "b0o/schemastore.nvim",
    "jose-elias-alvarez/typescript.nvim",
    {
      "j-hui/fidget.nvim",
      tag = "legacy", -- display the LSP progress
      event = "LspAttach",
    },
    {
      "SmiteshP/nvim-navic",
      event = "VeryLazy",
      config = function()
        require("nvim-navic").setup {}
      end,
    },
  },
  config = function()
    require("config.lsp").setup()
  end,
}
