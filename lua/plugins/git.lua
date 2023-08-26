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
      require("gitsigns").setup()
    end,
  }, -- gitgutter
  {
    "junegunn/gv.vim",
    cmd = { "GV" },
    config = function()
      -- add vim-fugitive first
      vim.cmd [[packadd vim-fugitive]]
    end,
  }, -- commit history
  {
    "rhysd/conflict-marker.vim",
    event = "VeryLazy",
    Lazy = true,
  },
}
