return {
  {
    "kyazdani42/nvim-web-devicons", -- filesystem icons
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup { default = true }
    end,
  },

  --[[ Highlights Under Cursor ]]
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        -- providers: provider used to get references in the buffer, ordered by priority
        providers = {
          "lsp",
          "treesitter",
        },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
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

  -- [[ Colorizer ]]
  {
    "norcalli/nvim-colorizer.lua",
    cmd = { "ColorizerToggle" },
    ft = { "css", "javascript", "html" },
    config = function()
      -- Attach to certain Filetypes, add special configuration for `html`
      -- Use `background` for everything else.
      require("colorizer").setup {
        "css",
        "javascript",
        html = {
          mode = "foreground",
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
      -- vim.cmd [[colorscheme catppuccin]]
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
      -- use this colorscheme nightfox/dayfox/dawnfox/duskfox/nordfox/terafox/carbonfox
      -- vim.cmd [[colorscheme carbonfox]]
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

  {
    "folke/tokyonight.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = { style = "moon" },
    init = function()
      -- Load the colorscheme
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme "tokyonight"
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
    config = function()
      require("todo-comments").setup {
        keywords = {
          FIX = {
            alt = { "fix", "FIX", "fixme", "FIXME", "bug", "BUG", "todo", "TODO" }, -- a set of other keywords that all map to this FIX keywords
          },
        },
      }
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

  -- [[ Improved UI and workflow for the Neovim quickfix ]]
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    config = function()
      vim.keymap.set("n", "<leader>ct", function()
        require("quicker").toggle()
      end, {
        desc = "Toggle quickfix",
      })
      vim.keymap.set("n", "<leader>lt", function()
        require("quicker").toggle { loclist = true }
      end, {
        desc = "Toggle loclist",
      })
      require("quicker").setup(
        ---@module "quicker"
        ---@type quicker.SetupOptions
        {
          keys = {
            {
              ">",
              function()
                require("quicker").expand { before = 2, after = 2, add_to_existing = true }
              end,
              desc = "Expand quickfix context",
            },
            {
              "<",
              function()
                require("quicker").collapse()
              end,
              desc = "Collapse quickfix context",
            },
          },
        }
      )
    end,
  },
}
