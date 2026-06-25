return {
  -- [[ Auto insert pairs ]]
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    config = function()
      require("config.autopairs").setup()
    end,
  },

  -- [[ Surround ]]
  {
    "kylechui/nvim-surround",
    enabled = true,
    version = "^3.0.0",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        keymaps = {
          insert = "<C-g>r",
          insert_line = "<C-g>R",
          normal = "yr",
          normal_cur = "yrr",
          normal_line = "yR",
          normal_cur_line = "yRR",
          visual = "R",
          visual_line = "gR",
          delete = "dr",
          change = "cr",
          change_line = "cR",
        },
      }
    end,
  },

  -- [[ Completion ]]
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    lazy = true,
    config = function()
      require("config.nvim_cmp").setup()
    end,
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        config = function()
          require("config.luasnip").setup()
        end,
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            "rafamadriz/friendly-snippets",
            config = function()
              -- require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      "saadparwaiz1/cmp_luasnip",

      -- other completion
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "onsails/lspkind-nvim",
      "windwp/nvim-autopairs",
      "ray-x/cmp-treesitter",
      -- AI
      {
        "zbirenbaum/copilot.lua",
        -- event = "InsertEnter",
        config = function()
          require("copilot").setup {
            suggestion = { enabled = false },
            panel = { enabled = false },
          }
        end,
        enabled = false,
      },
    },
  },

  -- [[ Comment ]]
  {
    "numToStr/Comment.nvim",
    lazy = true,
    event = "BufEnter",
  },
}
