local M = {}

-- Parsers to install
local parsers = {
  "bash",
  "regex",
  "c",
  "cpp",
  "cmake",
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
  "tsx",
  "gitcommit",
  "gitignore",
  "git_config",
  "git_rebase",
}

-- Languages to disable treesitter indent for
local indent_disabled = { python = true, java = true, rust = true, lua = true, go = true }

function M.setup()
  -- Setup tree-sitter-manager (handles parser installation and highlighting)
  require("tree-sitter-manager").setup {
    ensure_installed = parsers,
    highlight = true,
    border = "rounded",
    auto_install = true,
  }

  -- Enable treesitter-based indentation (experimental, skipped for some languages)
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterIndent", { clear = true }),
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      if indent_disabled[ft] then
        return
      end
      vim.bo[args.buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
    end,
  })

  -- Enable treesitter-based folding
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterFold", { clear = true }),
    callback = function(args)
      local win = vim.fn.bufwinid(args.buf)
      if win ~= -1 then
        vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[win][0].foldmethod = "expr"
      end
    end,
  })

  -- Incremental selection using core treesitter API
  local node_stack = {}

  -- Clear node_stack when leaving visual mode (Esc, <C-c>, etc.)
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = vim.api.nvim_create_augroup("TreesitterSelectionReset", { clear = true }),
    pattern = { "v:*", "V:*", "\x16:*" },
    callback = function()
      node_stack = {}
    end,
  })

  local function select_node(node)
    local buf = vim.api.nvim_get_current_buf()
    local sr, sc, er, ec = node:range()
    -- node:range() returns 0-indexed, end_col is exclusive
    if ec > 0 then
      ec = ec - 1
    else
      er = er - 1
      local line = vim.api.nvim_buf_get_lines(buf, er, er + 1, false)[1]
      ec = line and (#line - 1) or 0
    end
    vim.api.nvim_buf_set_mark(buf, "<", sr + 1, sc, {})
    vim.api.nvim_buf_set_mark(buf, ">", er + 1, ec, {})
    vim.cmd "normal! gv"
  end

  vim.keymap.set("n", "tnn", function()
    node_stack = {}
    local node = vim.treesitter.get_node()
    if node then
      table.insert(node_stack, node)
      select_node(node)
    end
  end, { desc = "Init treesitter selection" })

  vim.keymap.set("x", "v", function()
    local current = node_stack[#node_stack]
    if not current then
      local node = vim.treesitter.get_node()
      if node then
        node_stack = { node }
        select_node(node)
      end
      return
    end
    local parent = current:parent()
    if parent then
      table.insert(node_stack, parent)
      select_node(parent)
    end
  end, { desc = "Increment treesitter selection" })

  vim.keymap.set("x", "<BS>", function()
    if #node_stack > 1 then
      table.remove(node_stack)
      select_node(node_stack[#node_stack])
    end
  end, { desc = "Decrement treesitter selection" })

  -- vim-matchup: offscreen match display
  vim.g.matchup_matchparen_offscreen = { method = "popup" }
end

-- Textobjects setup (called by nvim-treesitter-textobjects plugin spec)
function M.setup_textobjects()
  local textobjects = require "nvim-treesitter-textobjects"

  textobjects.setup {
    select = {
      lookahead = true,
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
      },
      include_surrounding_whitespace = false,
    },
    move = {
      set_jumps = true,
    },
  }

  -- Select textobject keymaps
  local select_maps = {
    ["am"] = "@function.outer",
    ["im"] = "@function.inner",
    ["aC"] = "@class.outer",
    ["iC"] = "@class.inner",
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
  }

  for key, query in pairs(select_maps) do
    vim.keymap.set({ "x", "o" }, key, function()
      require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
    end, { desc = "TS: " .. query })
  end

  -- Move keymaps
  local move = require "nvim-treesitter-textobjects.move"

  vim.keymap.set({ "n", "x", "o" }, "]M", function()
    move.goto_next_start("@function.outer", "textobjects")
  end, { desc = "Next function start" })
  vim.keymap.set({ "n", "x", "o" }, "]]", function()
    move.goto_next_start("@class.outer", "textobjects")
  end, { desc = "Next class start" })
  vim.keymap.set({ "n", "x", "o" }, "]m", function()
    move.goto_next_end("@function.outer", "textobjects")
  end, { desc = "Next function end" })
  vim.keymap.set({ "n", "x", "o" }, "][", function()
    move.goto_next_end("@class.outer", "textobjects")
  end, { desc = "Next class end" })
  vim.keymap.set({ "n", "x", "o" }, "[m", function()
    move.goto_previous_start("@function.outer", "textobjects")
  end, { desc = "Prev function start" })
  vim.keymap.set({ "n", "x", "o" }, "[[", function()
    move.goto_previous_start("@class.outer", "textobjects")
  end, { desc = "Prev class start" })
  vim.keymap.set({ "n", "x", "o" }, "[M", function()
    move.goto_previous_end("@function.outer", "textobjects")
  end, { desc = "Prev function end" })
  vim.keymap.set({ "n", "x", "o" }, "[]", function()
    move.goto_previous_end("@class.outer", "textobjects")
  end, { desc = "Prev class end" })

  -- Swap keymaps
  local swap = require "nvim-treesitter-textobjects.swap"
  local swap_objects = {
    p = "@parameter.inner",
    f = "@function.outer",
    c = "@class.outer",
  }

  for key, obj in pairs(swap_objects) do
    vim.keymap.set("n", string.format("<Leader>sw%s", key), function()
      swap.swap_next(obj)
    end, { desc = "Swap next " .. obj })
    vim.keymap.set("n", string.format("<Leader>sW%s", key), function()
      swap.swap_previous(obj)
    end, { desc = "Swap prev " .. obj })
  end
end

return M
