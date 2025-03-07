-- [[ Keymap ]]

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    { "echasnovski/mini.icons", version = false },
  },
  config = function()
    require("config.whichkey").setup()
  end,
}
