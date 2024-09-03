-- [[ Fuzzy finder ]]

return {
  "nvim-telescope/telescope.nvim",
  event = "BufRead",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    "telescope-fzf-native.nvim",
    "plenary.nvim",
    "popup.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("config.telescope").setup()
  end,
}
