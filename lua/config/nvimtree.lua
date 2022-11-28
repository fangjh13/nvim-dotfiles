local M = {}

function M.setup()
    require('nvim-tree').setup {
        disable_netrw = true,
        hijack_netrw = true,
        filters = {
            custom = { "^.git$" },
        },
        git = {
            ignore = false,
        },
        sync_root_with_cwd = true,
        update_focused_file = {
            enable = true,
            update_cwd = true,
        },
        respect_buf_cwd = true,
    }
end

return M
