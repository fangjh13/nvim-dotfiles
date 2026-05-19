--[[ Status Line ]]

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-web-devicons",
  },
  config = function()
    require("config.lualine").setup()
  end,
}
