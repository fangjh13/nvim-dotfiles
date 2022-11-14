-- [[ plugins.lua ]]

local M = {}

function M.setup()
    local conf = {
        package_root = vim.fn.stdpath("config") .. "/site/pack",
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
        local install_path = fn.stdpath("config") .. "/site/pack/packer/start/packer.nvim"
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

        use 'wbthomason/packer.nvim' -- manage itself

        use { -- filesystem navigation
            'kyazdani42/nvim-tree.lua',
            requires = 'kyazdani42/nvim-web-devicons', -- filesystem icons
            config = function() require('nvim-tree').setup {
                    filters = {
                        custom = { "^.git$" },
                    },
                    git = {
                        ignore = false,
                    }
                }
            end
        }

        -- [[ Theme ]]
        use { 'mhinz/vim-startify' } -- start screen
        use { 'DanilaMihailov/beacon.nvim' } -- cursor jump
        use {
            'nvim-lualine/lualine.nvim', -- statusline
            requires = { 'kyazdani42/nvim-web-devicons',
                opt = true }
        }
        use { 'nvim-treesitter/nvim-treesitter',
            run = function()
                require('nvim-treesitter.install').update({ with_sync = true })
            end
        } -- highlight preview
        use { 'Mofiqul/dracula.nvim' }

        -- [[ Dev ]]
        use {
            'nvim-telescope/telescope.nvim', -- fuzzy finder
            requires = { { 'nvim-lua/plenary.nvim' } }
        }
        use { 'majutsushi/tagbar' } -- code structure
        use { 'Yggdroot/indentLine' } -- see indentation
        use { 'tpope/vim-fugitive' } -- git integration
        use { 'lewis6991/gitsigns.nvim',
            config = function()
                require('gitsigns').setup()
            end
        } -- gitgutter
        use { 'junegunn/gv.vim' } -- commit history
        use {
            'windwp/nvim-autopairs', -- auto insert pairs
            config = function() require('nvim-autopairs').setup {} end
        }
        use { 'neovim/nvim-lspconfig' } -- nvim buildin LSP

        -- [[ Debug ]]
        use { 'puremourning/vimspector' }

        -- [[ Snippets  ]]
        use { "L3MON4D3/LuaSnip",
            config = function()
                require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/snippets" })
            end
        }

        -- [[ Completion ]]
        use {
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { 'saadparwaiz1/cmp_luasnip' }
        }
        -- cmp fuzzy path
        use { 'romgrk/fzy-lua-native', run = 'make' }
        use { 'tzachar/cmp-fuzzy-path', requires = { 'hrsh7th/nvim-cmp', 'tzachar/fuzzy.nvim' } }

        -- [[ Github Copilot ]]
        -- use { "github/copilot.vim" }   -- github copilot only used get auth_token
        use {
            requires = {
                "zbirenbaum/copilot.lua",
                event = { "VimEnter" },
                config = function()
                    vim.defer_fn(function()
                        require("copilot").setup {
                            plugin_manager_path = vim.fn.stdpath("config") .. "/site/pack/packer"
                        }
                    end, 100)
                end,
            },
            "zbirenbaum/copilot-cmp", -- add copilot to cmp source
            after = { "copilot.lua" },
            config = function()
                require("copilot_cmp").setup()
            end
        }

        -- [[ Comment ]]
        use { 'tpope/vim-commentary' }

        -- [[ Switch Keyboard Layout ]]
        if vim.fn.has("mac") == 1 then
            use { "lyokha/vim-xkbswitch" }
        end
    end

    -- first init
    packer_init()
    local packer = require("packer")
    packer.init(conf)
    packer.startup(plugins)

end

return M
