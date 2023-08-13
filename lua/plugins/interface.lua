return {

  { "mhinz/vim-startify" }, -- start screen

  { "DanilaMihailov/beacon.nvim" }, -- cursor jump

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
  {
    "Mofiqul/dracula.nvim",
    config = function()
      vim.cmd [[colorscheme dracula]]
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
