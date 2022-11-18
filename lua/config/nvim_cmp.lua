local M = {}

function M.setup()
    -- Set up nvim-cmp.
    local cmp = require 'cmp'
    local feedkeys = require('cmp.utils.feedkeys')
    local keymap = require('cmp.utils.keymap')
    local luasnip = require("luasnip")
    local compare = require("cmp.config.compare")

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end


    cmp.setup({
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        window = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    buffer = "[Buffer]",
                    luasnip = "[Snip]",
                    nvim_lua = "[Lua]",
                    treesitter = "[Treesitter]",
                    path = "[Path]",
                })[entry.source.name]
                return vim_item
            end,
        },
        mapping = {

            ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
            ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
            ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s", "c" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s", "c" }),

            ["<CR>"] = cmp.mapping {
                i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                -- c = function(fallback)
                --     if cmp.visible() then
                --         cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
                --     else
                --         fallback()
                --     end
                -- end,
            },
        },


        sources = cmp.config.sources({
            { name = "treesitter" },
            { name = 'buffer' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = "nvim_lua" },
            { name = "path" },
            { name = "spell" },
            { name = "emoji" },
            { name = "calc" },
            { name = 'nvim_lsp', option = { use_show_condition = true } },
            -- { name = 'copilot' }, -- github copilot
        }),

        preselect = cmp.PreselectMode.None,

        sorting = {
            priority_weight = 2,
            -- comparators = {
            --     compare.offset,
            --     compare.exact,
            --     compare.score,
            --     compare.kind,
            --     -- compare.sort_text,
            --     compare.length,
            --     compare.order,
            -- },
            comparators = {
                compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
                compare.offset,
                --compare.order,
                --compare.sort_text,
                -- compare.exact,
                -- compare.kind,
                -- compare.length,
            }
        },
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
            { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
            { name = 'buffer' },
        })
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
            { name = 'path' },
            { name = 'cmdline' },
            -- { name = 'fuzzy_path', option = { fd_timeout_msec = 1500, fd_cmd = { 'fd', '-d', '20', '-p' } } }, -- fuzzy path
        })
    })

    -- auto pairs need install nvim-autopairs
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })

end

return M
