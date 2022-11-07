-- [[ plugs.lua ]]

return require('packer').startup({ function(use)
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

end,
    config = {
        package_root = vim.fn.stdpath("config") .. "/site/pack"
    } })
