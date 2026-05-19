-- [[ treesitter ]]

return {
  {
    "romus204/tree-sitter-manager.nvim",
    lazy = false,
    dependencies = {
      -- Install tree-sitter-cli parsers using mason.nvim
      {
        "mason-org/mason.nvim",
        opts = {
          ensure_installed = {
            "tree-sitter-cli",
          },
        },
      },
    },
    config = function()
      require("config.treesitter").setup()
    end,
  },
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
  -- Additional textobjects for treesitter (independent plugin, new API)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "romus204/tree-sitter-manager.nvim" },
    config = function()
      require("config.treesitter").setup_textobjects()
    end,
  },
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
  -- Rainbow parentheses by using tree-sitter
  {
    "hiphish/rainbow-delimiters.nvim",
  },
  -- End wise
  {
    "RRethy/nvim-treesitter-endwise",
    event = "InsertEnter",
    dependencies = { "romus204/tree-sitter-manager.nvim" },
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
  { "andymass/vim-matchup" },
}
