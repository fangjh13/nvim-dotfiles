-- [[ Fuzzy finder ]]

return {
  "nvim-telescope/telescope.nvim",
  event = "BufRead",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    "telescope-fzf-native.nvim",
    "plenary.nvim",
    "popup.nvim",
  },
  config = function()
    require("config.telescope").setup()
  end,
}
