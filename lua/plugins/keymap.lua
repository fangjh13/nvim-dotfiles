-- [[ Keymap ]]

return {
  "folke/which-key.nvim",
  lazy = true,
  version = "2.1.0",
  config = function()
    require("config.whichkey").setup()
  end,
}
