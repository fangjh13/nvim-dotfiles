-- [[ treesitter ]]

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
      -- Rainbow parentheses by using tree-sitter
      "hiphish/rainbow-delimiters.nvim",
      -- auto close and auto rename html tag
      {
        "windwp/nvim-ts-autotag",
        config = function()
          require("nvim-ts-autotag").setup {
            opts = {
              -- Defaults
              enable_close = true, -- Auto close tags
              enable_rename = true, -- Auto rename pairs of tags
              enable_close_on_slash = false, -- Auto close on trailing </
            },
          }
        end,
      },
      "andymass/vim-matchup",
      -- Show context of the current function
      {
        "nvim-treesitter/nvim-treesitter-context",
        enabled = true,
        opts = { enable = { "lua" }, mode = "cursor", max_lines = 3 },
        keys = {
          {
            "<leader>Ttc",
            function()
              local tsc = require "treesitter-context"
              tsc.toggle()
            end,
            desc = "Toggle context",
          },
        },
      },
    },
    config = function()
      require("config.treesitter").setup()
    end,
  },
  -- Additional textobjects for treesitter (independent plugin, new API)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("config.treesitter").setup_textobjects()
    end,
  },
  -- End wise
  {
    "RRethy/nvim-treesitter-endwise",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  -- commentstring
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
