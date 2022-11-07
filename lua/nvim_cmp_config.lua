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
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    --mapping = cmp.mapping.preset.insert({
    --  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    --  ['<C-f>'] = cmp.mapping.scroll_docs(4),
    --  --['<C-Space>'] = cmp.mapping.complete(),
    --  ['<Tab>'] = cmp.mapping.complete(),
    --  ['<C-e>'] = cmp.mapping.abort(),
    --  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    --}),

    -- mapping = {
    --     ['<Tab>'] = cmp.mapping(
    --         function()
    --             if cmp.visible() then
    --                 cmp.select_next_item()
    --             else
    --                 feedkeys.call(keymap.t('<Tab>'), 'n')
    --             end
    --         end,
    --         { "i", "s" }
    --     ),

    --     ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    -- },

    mapping = {

        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ['<C-e>'] = cmp.mapping.abort(),

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
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },


    sources = cmp.config.sources({
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'nvim_lsp', option = { use_show_condition = true } },
        { name = 'fuzzy_path', option = { fd_timeout_msec = 1500, fd_cmd = { 'fd', '-d', '20', '-p' } } }, -- fuzzy path
        { name = 'copilot' }, -- github copilot
    }, {
        { name = 'buffer' },
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
    -- mapping = cmp.mapping.preset.cmdline(),
    mapping = {
        ['<Tab>'] = {
            c = function()
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    feedkeys.call(keymap.t('<C-z>'), 'n')
                end
            end,
        },
        ['<S-Tab>'] = {
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    feedkeys.call(keymap.t('<C-z>'), 'n')
                end
            end,
        },
    },
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    --mapping = cmp.mapping.preset.cmdline(),
    mapping = {
        ['<Tab>'] = {
            c = function()
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    feedkeys.call(keymap.t('<C-z>'), 'n')
                end
            end,
        },
        ['<S-Tab>'] = {
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    feedkeys.call(keymap.t('<C-z>'), 'n')
                end
            end,
        },
    },
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' },
        { name = 'fuzzy_path', option = { fd_timeout_msec = 1500, fd_cmd = { 'fd', '-d', '20', '-p' } } }, -- fuzzy path
    })
})
