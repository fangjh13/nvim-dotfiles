local M = {}

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
  }
end

return M
