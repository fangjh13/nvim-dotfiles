--[[ keys.lua ]]
local map = vim.api.nvim_set_keymap

-- remap the key used to leave insert-- Toggle nvim-tree
map('n', '<leader>nf', [[:NvimTreeFindFile<cr>]], {})

-- Toggle more plugins
map('n', '<leader>l', [[:IndentLinesToggle<cr>]], {})
map('n', '<leader>t', [[:TagbarToggle<cr>]], {})
map('n', '<leader>ff', [[:Telescope find_files<cr>]], {})
