return {

  -- [[ Jumps ]]
  {
    "ggandor/leap.nvim",
    keys = { "s", "S" },
    config = function()
      local leap = require "leap"
      leap.add_default_mappings()
    end,
  },

  -- [[ Better % ]
  {
    "andymass/vim-matchup",
    event = "CursorMoved",
  },
}
