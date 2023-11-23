-- [[ treesitter ]]

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    event = "BufRead",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
      "andymass/vim-matchup",
      "RRethy/nvim-treesitter-endwise",
    },
    build = function()
      local ts_update = require("nvim-treesitter.install").update { with_sync = true }
      ts_update()
    end,
    config = function()
      require("config.treesitter").setup()
    end,
  },
  -- Auto tag
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup { enable = true }
    end,
  },
  -- End wise
  {
    "RRethy/nvim-treesitter-endwise",
    event = "InsertEnter",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    config = function()
      require("ts_context_commentstring").setup {
        enable_autocmd = false,
      }
      vim.g.skip_ts_context_commentstring_module = true
    end,
  },
}
