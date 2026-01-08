local M = {}

local cmp = require "cmp"
local feedkeys = require "cmp.utils.feedkeys"
local keymap = require "cmp.utils.keymap"
local compare = require "cmp.config.compare"
local lspkind = require "lspkind"
local luasnip = require "luasnip"

-- Set up nvim-cmp.
function M.setup()
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
  end

  cmp.setup {
    enabled = function()
      local context = require "cmp.config.context"
      if vim.api.nvim_get_mode().mode == "c" then
        return true
      elseif vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
        -- disable completion in prompt mode
        return false
      else
        -- disable completion in comments
        return not context.in_treesitter_capture "comment" and not context.in_syntax_group "Comment"
      end
    end,

    completion = {
      completeopt = "menu,menuone,noselect",
      keyword_length = 1,
    },

    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    -- experimental = {
    --   ghost_text = true,
    -- },
    mapping = {
      -- Scroll the documentation window [b]ack / [f]orward
      ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),

      -- Select the [p]revious item
      ["<C-p>"] = cmp.mapping {
        c = function()
          if cmp.visible() then
            cmp.select_prev_item() -- change inputted text
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Up>", true, true, true), "n", true)
          end
        end,
        i = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
          else
            fallback()
          end
        end,
      },
      -- Select the [n]ext item
      ["<C-n>"] = cmp.mapping {
        c = function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, true, true), "n", true)
          end
        end,
        i = function(fallback)
          if cmp.visible() then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
          else
            fallback()
          end
        end,
      },
      ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),

      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          if vim.api.nvim_get_mode().mode == "i" then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
          else
            cmp.select_next_item()
          end
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
          if vim.api.nvim_get_mode().mode == "i" then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
          else
            cmp.select_prev_item {}
          end
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s", "c" }),

      -- Accept currently selected item.
      ["<CR>"] = cmp.mapping {
        i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      },
    },
    sources = cmp.config.sources {
      {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
      },
      { name = "nvim_lsp", max_item_count = 15 },
      { name = "nvim_lsp_signature_help", max_item_count = 5 },
      { name = "luasnip", max_item_count = 5 },
      { name = "treesitter", max_item_count = 5 },
      { name = "buffer", max_item_count = 5 },
      { name = "nvim_lua" },
      { name = "path" },
      -- { name = "codeium",                 group_index = 1 }, -- ai coding codeium
    },
    ---@diagnostic disable: missing-fields
    formatting = {
      format = lspkind.cmp_format {
        mode = "symbol_text", -- show symbol and text annotations
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        show_labelDetails = true, -- show labelDetails in menu. Disabled by default
        symbol_map = {
          Copilot = "",
          Codeium = "",
        },
      },
    },

    preselect = cmp.PreselectMode.None,

    sorting = {
      priority_weight = 2,
      comparators = {
        compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
        compare.recently_used,
        compare.offset,
        compare.exact,
        compare.kind,
        compare.sort_text,
        compare.length,
        compare.order,
      },
    },
  }

  -- Set configuration for specific filetype.
  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = "buffer" },
    }),
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(":", {
    sources = cmp.config.sources {
      { name = "path" },
      { name = "cmdline" },
      -- { name = 'fuzzy_path', option = { fd_timeout_msec = 1500, fd_cmd = { 'fd', '-d', '20', '-p' } } }, -- fuzzy path
    },
  })

  -- auto pairs need install nvim-autopairs
  local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
