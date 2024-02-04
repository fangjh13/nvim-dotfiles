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
        enabled = false,
      },
      -- AI Coding with Github copilot
      {
        "zbirenbaum/copilot-cmp", -- add copilot to cmp source
        config = function()
          require("copilot_cmp").setup()
        end,
        enabled = false,
      },
      -- AI Coding with codeium.nvim
      {
        "Exafunction/codeium.nvim",
        config = function()
          require("codeium").setup {}
        end,
        enabled = true,
      },
    },
  },
  -- AI Coding For Code Generation With codeium.vim
  {
    "Exafunction/codeium.vim",
    enabled = true,
    event = "InsertEnter",
    -- stylua: ignore
    config = function ()
      vim.g.codeium_disable_bindings = 1
      vim.keymap.set("i", "<C-f>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<A-]>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<A-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
      vim.keymap.set("i", "<A-Bslash>", function() return vim.fn["codeium#Complete"]() end, { expr = true })
    end,
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
