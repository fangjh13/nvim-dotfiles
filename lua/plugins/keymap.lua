-- [[ Keymap ]]

return {
  "folke/which-key.nvim",
  lazy = true,
  config = function()
    require("config.whichkey").setup()
  end,
}
