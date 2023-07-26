local M = {}

local swap_next, swap_prev = (function()
  local swap_objects = {
    p = "@parameter.inner",
    f = "@function.outer",
    c = "@class.outer",
  }

  local n, p = {}, {}
  for key, obj in pairs(swap_objects) do
    n[string.format("<Leader>sw%s", key)] = obj
    p[string.format("<Leader>sW%s", key)] = obj
  end

  return n, p
end)()

local function ts_disable(_, bufnr)
  return vim.api.nvim_buf_line_count(bufnr) > 5000
end

function M.setup()
  require("nvim-treesitter.configs").setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = "all",
    -- ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    highlight = {
      enable = true, -- false will disable the whole extension
      -- disable in large file
      -- from https://github.com/nvim-treesitter/nvim-treesitter/issues/556
      disable = function(lang, bufnr)
        return lang == "cmake" or ts_disable(lang, bufnr)
      end,
      additional_vim_regex_highlighting = { "latex" },
    },

    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil,
    },

    indent = {
      enable = true,
      disable = { "python", "java", "rust", "lua", "go" },
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        -- mappings for incremental selection (visual mappings)
        init_selection = "tnn", -- maps in normal mode to init the node/scope selection
        node_incremental = "v", -- increment to the upper named parent
        node_decremental = "<BS>", -- decrement to the previous node
        scope_incremental = "tsi", -- increment to the upper scope
      },
    },

    -- need install vim-matchup
    matchup = {
      enable = true,
    },

    -- nvim-treesitter-textsubjects
    textsubjects = {
      enable = true,
      prev_selection = ",", -- (Optional) keymap to select the previous selection
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-container-outer",
        ["i;"] = "textsubjects-container-inner",
      },
    },

    -- nvim-treesitter-textobjects
    textobjects = {
      -- syntax-aware textobjects
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
          ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
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
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },

        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "<c-v>", -- blockwise
        },
      },
      -- parameter swapping
      swap = {
        enable = true,
        swap_next = swap_next,
        swap_previous = swap_prev,
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
    },
  }
end

return M
