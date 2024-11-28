local M = {}

local icons = require "config.icons"

function M.setup()
  require("nvim-tree").setup {
    disable_netrw = false,
    hijack_netrw = true,
    view = {
      number = false,
      relativenumber = false,
    },
    filters = {
      custom = { "^.git$" },
    },
    git = {
      ignore = false,
    },
    sync_root_with_cwd = false,
    update_focused_file = {
      enable = false,
      update_cwd = true,
    },
    respect_buf_cwd = false,
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = icons.diagnostics.Hint,
        info = icons.diagnostics.Info,
        warning = icons.diagnostics.Warning,
        error = icons.diagnostics.Error,
      },
    },
    renderer = {
      highlight_git = true,
    },
  }
end

return M
