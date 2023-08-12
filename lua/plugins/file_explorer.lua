-- [[ File Explorer ]]

return {
  {
    "kyazdani42/nvim-tree.lua", -- filesystem navigation
    dependencies = "nvim-web-devicons",
    cmd = { "NvimTreeToggle", "NvimTreeClose", "NvimTreeFindFile", "NvimTreeRefresh" },
    config = function()
      require("config.nvimtree").setup()
    end,
  },
  -- [[ Better Netrw ]]
  { "tpope/vim-vinegar" },
}
