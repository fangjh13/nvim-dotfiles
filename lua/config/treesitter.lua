local M = {}

function M.setup()
    require('nvim-treesitter.configs').setup {
        highlight = {
            enable = true, -- false will disable the whole extension
        },

        indent = {
            enable = true
        },

        incremental_selection = {
            enable = true,
            keymaps = { -- mappings for incremental selection (visual mappings)
                init_selection = 'tnn', -- maps in normal mode to init the node/scope selection
                node_incremental = 'tni', -- increment to the upper named parent
                scope_incremental = 'tsi', -- increment to the upper scope
                node_decremental = 'tnd', -- decrement to the previous node
            },
        },
        textobjects = { -- syntax-aware textobjects
            enable = true,
            disable = {},
            keymaps = {
                ['iL'] = { -- you can define your own textobjects directly here
                    python = '(function_definition) @function',
                    cpp = '(function_definition) @function',
                    c = '(function_definition) @function',
                    java = '(method_declaration) @function',
                },
                -- or you use the queries from supported languages with textobjects.scm
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['aC'] = '@class.outer',
                ['iC'] = '@class.inner',
                ['ac'] = '@conditional.outer',
                ['ic'] = '@conditional.inner',
                ['ae'] = '@block.outer',
                ['ie'] = '@block.inner',
                ['al'] = '@loop.outer',
                ['il'] = '@loop.inner',
                ['is'] = '@statement.inner',
                ['as'] = '@statement.outer',
                ['ad'] = '@comment.outer',
                ['am'] = '@call.outer',
                ['im'] = '@call.inner',
            },
        },
        ensure_installed = {
            'bash',
            'c',
            'cpp',
            'css',
            'html',
            'javascript',
            'json',
            'jsonc',
            'latex',
            'lua',
            'python',
            'toml',
            'typescript',
            'vue',
            'yaml',
            'go'
        }
    }
end

return M
