-- [[ plugins.lua ]]

local M = {}

function M.setup()
  local conf = {
    profile = {
      enable = true,
      threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  -- Indicate first time installation
  local packer_bootstrap = false

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

  -- Plugins
  local function plugins(use)
    use "wbthomason/packer.nvim" -- manage itself

    use {
      "kyazdani42/nvim-web-devicons", -- filesystem icons
      module = "nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup { default = true }
      end,
    }

    -- [[ File Explorer ]]
    use {
      "kyazdani42/nvim-tree.lua", -- filesystem navigation
      wants = "nvim-web-devicons",
      cmd = { "NvimTreeToggle", "NvimTreeClose", "NvimTreeFindFile", "NvimTreeRefresh" },
      config = function()
        require("config.nvimtree").setup()
      end,
    }

    use { "mhinz/vim-startify" } -- start screen
    use { "DanilaMihailov/beacon.nvim" } -- cursor jump
    --[[ Status Line ]]
    use {
      "nvim-lualine/lualine.nvim",
      after = "nvim-treesitter",
      wants = "nvim-web-devicons",
      config = function()
        require("config.lualine").setup()
      end,
    }

    -- [[ Better Netrw ]]
    use { "tpope/vim-vinegar" }

    -- [[ treesitter ]]
    use {
      "nvim-treesitter/nvim-treesitter",
      opt = true,
      event = "BufRead",
      requires = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        "windwp/nvim-ts-autotag",
        "JoosepAlviste/nvim-ts-context-commentstring",
      },
      run = function()
        local ts_update = require("nvim-treesitter.install").update { with_sync = true }
        ts_update()
      end,
      config = function()
        require("config.treesitter").setup()
      end,
    } -- highlight preview

    -- Auto tag
    use {
      "windwp/nvim-ts-autotag",
      wants = "nvim-treesitter",
      event = "InsertEnter",
      config = function()
        require("nvim-ts-autotag").setup { enable = true }
      end,
    }

    -- End wise
    use {
      "RRethy/nvim-treesitter-endwise",
      wants = "nvim-treesitter",
      event = "InsertEnter",
      disable = false,
    }

    -- [[ User interface ]]
    use {
      "stevearc/dressing.nvim",
      event = "BufEnter",
      config = function()
        require("dressing").setup {
          select = {
            backend = { "telescope", "fzf", "builtin" },
          },
        }
      end,
      disable = true,
    }

    use {
      "Mofiqul/dracula.nvim",
      config = function()
        vim.cmd [[colorscheme dracula]]
      end,
    }

    use {
      "nvim-telescope/telescope.nvim", -- fuzzy finder
      event = "BufRead",
      requires = { "nvim-lua/plenary.nvim" },
    }
    use { "majutsushi/tagbar" } -- code structure
    --[[ Indent Line ]]
    use {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufReadPre",
      config = function()
        require("config.indentblankline").setup()
      end,
    }
    use { "tpope/vim-fugitive" } -- git integration
    use {
      "lewis6991/gitsigns.nvim",
      event = "BufReadPre",
      wants = "plenary.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("gitsigns").setup()
      end,
    } -- gitgutter
    use { "junegunn/gv.vim" } -- commit history
    use {
      "windwp/nvim-autopairs", -- auto insert pairs
      wants = "nvim-treesitter",
      module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
      config = function()
        require("config.autopairs").setup()
      end,
    }
    use {
      "neovim/nvim-lspconfig",
      opt = true,
      event = "BufReadPre",
      -- wants = { "cmp-nvim-lsp", "nvim-lsp-installer", "lsp_signature.nvim" },
      wants = {
        "cmp-nvim-lsp",
        "lua-dev.nvim",
        "vim-illuminate",
        "null-ls.nvim",
      },
      config = function()
        require("config.lsp").setup()
      end,
      requires = {
        --    "williamboman/nvim-lsp-installer",
        "RRethy/vim-illuminate",
        "folke/lua-dev.nvim",
        "jose-elias-alvarez/null-ls.nvim",
        {
          "j-hui/fidget.nvim", -- display the LSP progress
          config = function()
            require("fidget").setup {}
          end,
        },
      },
    } -- nvim buildin LSP

    -- [[ Motions ]]
    use { "andymass/vim-matchup", event = "CursorMoved" }

    -- [[ Debug ]]
    use {
      "puremourning/vimspector",
      cmd = { "VimspectorInstall", "VimspectorUpdate" },
      fn = { "vimspector#Launch()", "vimspector#ToggleBreakpoint", "vimspector#Continue" },
      config = function()
        require("config.vimspector").setup()
      end,
    }

    -- [[ Completion ]]
    use {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      opt = true,
      config = function()
        require("config.nvim_cmp").setup()
      end,
      wants = { "LuaSnip" },
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        {
          "L3MON4D3/LuaSnip", -- [[ Snippets ]]
          wants = { "friendly-snippets", "vim-snippets" },
          config = function()
            require("config.luasnip").setup()
          end,
        },
        "rafamadriz/friendly-snippets",
        "honza/vim-snippets",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        -- "hrsh7th/cmp-calc",
        -- "f3fora/cmp-spell",
        -- "hrsh7th/cmp-emoji",
        -- cmp fuzzy path
        -- { 'romgrk/fzy-lua-native', run = 'make' },
        -- { 'tzachar/cmp-fuzzy-path', requires = { 'hrsh7th/nvim-cmp', 'tzachar/fuzzy.nvim' } },
      },
    }

    -- cmp fuzzy path
    -- use {'romgrk/fzy-lua-native', run = 'make'}
    -- use "hrsh7th/nvim-cmp"
    -- use {'tzachar/cmp-fuzzy-path', requires = {'hrsh7th/nvim-cmp', 'tzachar/fuzzy.nvim'}}

    -- [[ Github Copilot ]]
    -- use { "github/copilot.vim" }   -- github copilot only used get auth_token
    use {
      "zbirenbaum/copilot-cmp", -- add copilot to cmp source
      requires = {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        config = function()
          vim.defer_fn(function()
            require("copilot").setup {
              plugin_manager_path = vim.fn.stdpath "data" .. "/site/pack/packer",
            }
          end, 100)
        end,
      },
      after = { "copilot.lua" },
      config = function()
        require("copilot_cmp").setup()
      end,
    }

    -- [[ Comment ]]
    use {
      "numToStr/Comment.nvim",
      opt = true,
      event = "BufEnter",
      config = function()
        require("Comment").setup {}
      end,
    }

    -- [[ Switch Keyboard Layout ]]
    if vim.fn.has "mac" == 1 then
      use { "lyokha/vim-xkbswitch" }
    end

    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  -- install, if not exists install it
  packer_init()
  -- config
  local packer = require "packer"
  packer.init(conf)
  packer.startup(plugins)
end

return M
