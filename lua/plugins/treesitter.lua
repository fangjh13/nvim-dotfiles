-- [[ treesitter ]]

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- Rainbow parentheses by using tree-sitter
      "hiphish/rainbow-delimiters.nvim",
      -- Additional textobjects for treesitter
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- auto close and auto rename html tag
      {
        "windwp/nvim-ts-autotag",
        config = function()
          require("nvim-ts-autotag").setup {
            opts = {
              -- Defaults
              enable_close = true,           -- Auto close tags
              enable_rename = true,          -- Auto rename pairs of tags
              enable_close_on_slash = false, -- Auto close on trailing </
            },
          }
        end,
      },
      -- End wise
      {
        "RRethy/nvim-treesitter-endwise",
        event = "InsertEnter",
      },
      "andymass/vim-matchup",
      "RRethy/nvim-treesitter-endwise",
      "JoosepAlviste/nvim-ts-context-commentstring",
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
    build = function()
      local ts_update = require("nvim-treesitter.install").update { with_sync = true }
      ts_update()
    end,
    config = function()
      require("config.treesitter").setup()
    end,
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
