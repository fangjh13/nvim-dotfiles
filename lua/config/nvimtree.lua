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
        }
    }
end

return M
