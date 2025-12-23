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
        "Exafunction/windsurf.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "hrsh7th/nvim-cmp",
        },
        config = function()
          require("codeium").setup {
            virtual_text = {
              enabled = true,
              -- Set to true if you never want completions to be shown automatically.
              manual = false,
              -- A mapping of filetype to true or false, to enable virtual text.
              -- Disable for command-line windows (empty filetype) and Telescope prompts.
              filetypes = {
                [""] = false,
                TelescopePrompt = false,
              },
              -- Whether to enable virtual text of not for filetypes not specifically listed above.
              default_filetype_enabled = true,
              -- How long to wait (in ms) before requesting completions after typing stops.
              idle_delay = 75,
              -- Priority of the virtual text. This usually ensures that the completions appear on top of
              -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
              -- desired.
              virtual_text_priority = 65535,
              -- Set to false to disable all key bindings for managing completions.
              map_keys = true,
              -- The key to press when hitting the accept keybinding but no completion is showing.
              -- Defaults to \t normally or <c-n> when a popup is showing.
              accept_fallback = nil,
              -- Key bindings for managing completions in virtual text mode.
              key_bindings = {
                -- Accept the current completion.
                accept = "<C-f>",
                -- Accept the next word
                accept_word = false,
                -- Accept the next line.
                accept_line = false,
                -- Clear the virtual text.
                clear = false,
                -- Cycle to the next completion.
                next = "<A-]>",
                -- Cycle to the previous completion.
                prev = "<A-[>",
              },
            },
          }
        end,
        enabled = true,
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
