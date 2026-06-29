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
    },
  },

  -- [[ AI Coding Assistant ]]
  {
    -- GitHub Copilot
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-F>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-e>",
        },
      },
      server_opts_overrides = {
        settings = {
          telemetry = {
            telemetryLevel = "off",
          },
        },
      },
    },
  },

  {
    -- Code Compeletion from self provider like OpenAI, Gemini, self-hosted LLMs, etc.
    "milanglacier/minuet-ai.nvim",
    enabled = false,
    config = function()
      require("minuet").setup {
        provider = "gemini",
        request_timeout = 2.5,
        throttle = 1500,
        debounce = 600,
        n_completions = 1,
        provider_options = {
          gemini = {
            api_key = "GEMINI_API_KEY", -- NOTE: Need to manually be set in environment variable
            model = "gemini-3.5-flash",
            optional = {
              generationConfig = {
                maxOutputTokens = 256,
                thinkingConfig = {
                  -- Disable thinking for gemini 3.x models
                  thinkingLevel = "minimal",
                },
              },
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = { "*" },
          auto_trigger_ignore_ft = {
            "TelescopePrompt",
            "neo-tree",
            "help",
            "lazy",
            "mason",
            "notify",
          },
          keymap = {
            accept = "<C-F>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-e>",
          },
          show_on_completion_menu = true,
        },
        -- Control notification display for request status
        -- value use = false / "debug" /  "verbose" / "warn" / "error"
        notify = "warn",
      }
    end,
  },

  -- [[ Comment ]]
  {
    "numToStr/Comment.nvim",
    lazy = true,
    event = "BufEnter",
  },
}
