--[[ Status Line ]]

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-treesitter",
    "nvim-web-devicons",
  },
  config = function()
    require("config.lualine").setup()
  end,
}
