return {
  -- [[ Auto insert pairs ]]
  {
    "windwp/nvim-autopairs",
    config = function()
      require("config.autopairs").setup()
    end,
  },

  -- [[ Surround ]]
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        keymaps = {
          visual = "R",
        },
      }
    end,
  },

  -- [[ Completion ]]
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    lazy = true,
    config = function()
      require("config.nvim_cmp").setup()
    end,
    dependencies = {
      "LuaSnip",
      "windwp/nvim-autopairs",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "ray-x/cmp-treesitter",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "onsails/lspkind-nvim",
      {
        "zbirenbaum/copilot.lua",
        -- event = "InsertEnter",
        config = function()
          require("copilot").setup {
            suggestion = { enabled = false },
            panel = { enabled = false },
          }
        end,
      },
      {
        "zbirenbaum/copilot-cmp", -- add copilot to cmp source
        config = function()
          require("copilot_cmp").setup()
        end,
      },
      -- "hrsh7th/cmp-calc",
      -- "f3fora/cmp-spell",
      -- "hrsh7th/cmp-emoji",
      -- cmp fuzzy path
      -- { 'romgrk/fzy-lua-native', build = 'make' },
      -- { 'tzachar/cmp-fuzzy-path', dependencies = { 'hrsh7th/nvim-cmp', 'tzachar/fuzzy.nvim' } },
    },
  },

  -- [[ Comment ]]
  {
    "numToStr/Comment.nvim",
    lazy = true,
    event = "BufEnter",
    config = function()
      require("Comment").setup {}
    end,
  },
}
