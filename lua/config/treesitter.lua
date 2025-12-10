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

function M.setup()
  require("nvim-treesitter.configs").setup {
    modules = {},

    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = {
      "bash",
      "regex",
      "c",
      "lua",
      "vim",
      "vimdoc",
      "rust",
      "ron",
      "query",
      "make",
      "perl",
      "proto",
      "markdown",
      "markdown_inline",
      "python",
      "requirements",
      "go",
      "gomod",
      "gosum",
      "gotmpl",
      "gowork",
      "xml",
      "html",
      "yaml",
      "toml",
      "css",
      "csv",
      "json",
      "javascript",
      "dockerfile",
      "sql",
      "ssh_config",
      "typescript",
      "gitcommit",
      "gitignore",
      "git_config",
      "git_rebase",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    -- List of parsers to ignore installing (or "all")
    ignore_install = {},

    highlight = {
      enable = true,
      use_languagetree = true,
      -- disable slow treesitter highlight for large files
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
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
          ["am"] = "@function.outer",
          ["im"] = "@function.inner",
          ["aC"] = "@class.outer",
          ["iC"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          ["ac"] = "@conditional.outer",
          ["ic"] = "@conditional.inner",
          ["ae"] = "@block.outer",
          ["ie"] = "@block.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["as"] = "@statement.inner",
          ["is"] = "@statement.outer",
          ["id"] = "@comment.inner",
          ["ad"] = "@comment.outer",
          ["af"] = "@call.outer",
          ["if"] = "@call.inner",
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

    -- endwise need [RRethy/nvim-treesitter-endwise](https://github.com/RRethy/nvim-treesitter-endwise) installed
    endwise = {
      enable = true,
    },
  }
end

return M
