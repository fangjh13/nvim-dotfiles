local M = {}
local actions = require "telescope.actions"

function M.setup()
  -- Enable Telescope extensions if they are installed
  pcall(require("telescope").load_extension, "fzf")
  pcall(require("telescope").load_extension, "ui-select")

  local builtin = require "telescope.builtin"

  vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
  vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

  vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = "[/] Fuzzily search in current buffer" })

  -- 全词匹配搜索光标下的词
  vim.keymap.set("n", "gs", function()
    builtin.grep_string { word_match = "-w" }
  end)
  -- visual 模式下搜索选定内容放到f寄存器
  vim.keymap.set("v", "gs", function()
    vim.cmd.normal '"fy'
    builtin.grep_string { search = vim.fn.getreg '"f' }
  end)

  -- 按1<leader>fg, 表示开启正则匹配
  -- 按2<leader>fg, 则表示开启全词匹配
  -- 按3<leader>fg, 则表示区分大小写
  local function live_grep_opts(opts)
    local flags = tostring(vim.v.count)
    local additional_args = {}
    local prompt_title = "Live Grep"
    if flags:find "1" then
      prompt_title = prompt_title .. " [.*]"
    else
      table.insert(additional_args, "--fixed-strings")
    end
    if flags:find "2" then
      prompt_title = prompt_title .. " [w]"
      table.insert(additional_args, "--word-regexp")
    end
    if flags:find "3" then
      prompt_title = prompt_title .. " [Aa]"
      table.insert(additional_args, "--case-sensitive")
    end

    opts = opts or {}
    opts.additional_args = function()
      return additional_args
    end
    opts.prompt_title = prompt_title
    return opts
  end
  vim.keymap.set("n", "<leader>fg", function()
    builtin.live_grep(live_grep_opts {})
  end)

  M.default()
end

function M.default()
  require("telescope").setup {
    defaults = {
      -- Default configuration for telescope goes here:
      mappings = {
        n = {
          ["q"] = actions.smart_add_to_qflist + actions.open_qflist,
          ["v"] = actions.file_vsplit,
          ["x"] = actions.file_split,
          ["<C-d>"] = actions.results_scrolling_down,
          ["<C-u>"] = actions.results_scrolling_up,
          ["<C-f>"] = actions.results_scrolling_right,
          ["<C-b>"] = actions.results_scrolling_left,
          ["<PageUp>"] = actions.preview_scrolling_up,
          ["<PageDown>"] = actions.preview_scrolling_down,
          ["<M-f>"] = actions.preview_scrolling_right,
          ["<M-b>"] = actions.preview_scrolling_left,
          ["D"] = actions.delete_buffer,
        }, -- n
        i = {
          ["<C-h>"] = "which_key",
          ["<C-d>"] = actions.results_scrolling_down,
          ["<C-u>"] = actions.results_scrolling_up,
          ["<C-f>"] = actions.results_scrolling_right,
          ["<C-b>"] = actions.results_scrolling_left,
          ["<PageUp>"] = actions.preview_scrolling_up,
          ["<PageDown>"] = actions.preview_scrolling_down,
          ["<M-f>"] = actions.preview_scrolling_right,
          ["<M-b>"] = actions.preview_scrolling_left,
          ["D"] = actions.delete_buffer,
        }, -- i
      },   -- mappings
    },     -- defaults
    pickers = {
      buffers = {
        sort_mru = true,
      },
    },
  } -- telescope setup
end

return M
