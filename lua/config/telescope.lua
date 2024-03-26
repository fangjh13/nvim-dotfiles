local M = {}

function M.setup()
  local builtin = require "telescope.builtin"

  vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
  vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

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
      -- config_key = value,
      mappings = {
        n = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        }, -- n
        i = {
          ["<C-h>"] = "which_key",
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        }, -- i
      }, -- mappings
    }, -- defaults
  } -- telescope setup
end

return M
