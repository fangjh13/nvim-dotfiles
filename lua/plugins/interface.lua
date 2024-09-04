return {

  { "mhinz/vim-startify" }, -- start screen

  { "DanilaMihailov/beacon.nvim", lazy = true }, -- cursor jump

  {
    "kyazdani42/nvim-web-devicons", -- filesystem icons
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup { default = true }
    end,
  },

  --[[ Indent Blankline ]]
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
      require("config.indentblankline").setup()
    end,
  },

  -- [[ User interface ]]
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup {
        input = { relative = "editor" },
        select = {
          backend = { "telescope", "fzf", "builtin" },
        },
      }
    end,
  },

  -- [[ Colorscheme ]
  -- choose your favorite colorscheme in https://dotfyle.com/neovim/colorscheme/top

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      -- use this colorscheme
      -- catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
      vim.cmd [[colorscheme catppuccin]]
    end,
  },

  {
    "Mofiqul/dracula.nvim",
    -- use this colorscheme
    -- config = function()
    --   vim.cmd [[colorscheme dracula]]
    -- end,
  },

  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup {
        options = {
          styles = {
            comments = "italic",
            -- keywords = "bold",
            -- types = "italic,bold",
          },
        },
      }
      -- use this colorscheme
      -- vim.cmd [[colorscheme nightfox]]
    end,
  },

  {
    "shaunsingh/nord.nvim",
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = false

      -- Load the colorscheme
      -- require("nord").set()
    end,
  },

  -- [[ Better quickfix window ]]
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup()
    end,
  },
}
