local M = {}

function M.setup()
    require('lualine').setup {
        options = {
            theme = 'dracula-nvim'
        }
    }
end

return M
