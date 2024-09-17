-- [[ Git ]]

return {
  {
    "tpope/vim-fugitive", -- git wrapper
    cmd = { "Git", "G", "Ggrep", "Gdiffsplit", "Gvdiffsplit" },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.gitsigns").setup()
    end,
  }, -- gitgutter
  {
    "junegunn/gv.vim",
    cmd = { "GV" },
    dependencies = { "tpope/vim-fugitive" },
  }, -- commit history
  {
    "rhysd/conflict-marker.vim",
    event = "VeryLazy",
    Lazy = true,
  },
}
