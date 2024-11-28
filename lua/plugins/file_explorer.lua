-- [[ File Explorer ]]

return {
  {
    "kyazdani42/nvim-tree.lua", -- filesystem navigation
    dependencies = "nvim-web-devicons",
    cmd = { "NvimTreeToggle", "NvimTreeClose", "NvimTreeFindFile", "NvimTreeRefresh" },
    config = function()
      require("config.nvimtree").setup()
    end,
    init = function()
      local map = require("utils").map
      map("n", "<leader>nf", [[:NvimTreeFindFile<cr>]])
      map("n", "<leader>zz", [[:NvimTreeToggle<cr>]])
    end,
  },
  -- [[ Better Netrw ]]
  { "tpope/vim-vinegar" },
}
