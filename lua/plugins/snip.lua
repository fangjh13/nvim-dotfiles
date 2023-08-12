-- [[ Snippets ]]

return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "honza/vim-snippets",
  },
  -- install jsregexp
  build = "make install_jsregexp",
  config = function()
    require("config.luasnip").setup()
  end,
}
