local M = {}

function M.setup()
    require("nvim-treesitter.configs").setup {
        highlight = {
            enable = true, -- false will disable the whole extension
        },

        indent = {
            enable = true,
        },

        incremental_selection = {
            enable = true,
            keymaps = { -- mappings for incremental selection (visual mappings)
                init_selection = "tnn", -- maps in normal mode to init the node/scope selection
                node_incremental = "tni", -- increment to the upper named parent
                node_decremental = "tnd", -- decrement to the previous node
                scope_incremental = "tsi", -- increment to the upper scope
            },
        },

        -- need install vim-matchup
        matchup = {
            enable = true,
        },

        -- nvim-treesitter-textobjects
        textobjects = { -- syntax-aware textobjects
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    -- ['iL'] = { -- you can define your own textobjects directly here
                    --     python = '(function_definition) @function',
                    --     cpp = '(function_definition) @function',
                    --     c = '(function_definition) @function',
                    --     java = '(method_declaration) @function',
                    -- },
                    -- or you use the queries from supported languages with textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["aC"] = "@conditional.outer",
                    ["iC"] = "@conditional.inner",
                    ["ae"] = "@block.outer",
                    ["ie"] = "@block.inner",
                    ["al"] = "@loop.outer",
                    ["il"] = "@loop.inner",
                    ["is"] = "@statement.inner",
                    ["as"] = "@statement.outer",
                    ["ad"] = "@comment.outer",
                    ["am"] = "@call.outer",
                    ["im"] = "@call.inner",
                },
            },

            -- parameter swapping
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>sx"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>sX"] = "@parameter.inner",
                },
            },

            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]M"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]m"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            },

            lsp_interop = {
                enable = true,
                border = "none",
                peek_definition_code = {
                    ["<leader>df"] = "@function.outer",
                    ["<leader>dF"] = "@class.outer",
                },
            },
        },
        ensure_installed = {
            "bash",
            "c",
            "cmake",
            "cpp",
            "css",
            "html",
            "javascript",
            "json",
            "jsonc",
            "latex",
            "sql",
            "diff",
            "regex",
            "lua",
            "python",
            "toml",
            "dockerfile",
            "typescript",
            "vue",
            "yaml",
            "vim",
            "go",
            "gomod",
            "gowork",
            "rust",
            "markdown",
        },

        -- endwise need RRethy/nvim-treesitter-endwise installed
        endwise = {
            enable = true,
        },

        -- autotag need windwp/nvim-ts-autotag installed
        autotag = {
            enable = true,
        },

        -- context_commentstring need nvim-ts-context-commentstring installed
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
    }
end

return M
