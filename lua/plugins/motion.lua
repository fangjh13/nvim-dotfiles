return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        "s", -- `alt + s` can used in insert mode
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter {
            -- Simulate nvim-treesitter incremental selection
            actions = {
              ["v"] = "next",
              ["<BS>"] = "prev",
            },
          }
        end,
        desc = "Flash Treesitter",
      },
      -- Remote action
      -- Perform an action in a remote location, Once returning to Normal mode, it jumps back
      --  Example: `yzr{leap}y` copy remote line
      {
        "zr",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
    },
  },

  -- Better % , Adds motions g%, [%, ]%, and z%
  {
    "andymass/vim-matchup",
    ---@type matchup.Config
    opts = {
      treesitter = {
        stopline = 500,
      },
    },
  },
}
