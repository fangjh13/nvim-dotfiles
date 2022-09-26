--[[ maps.lua ]]
local map = vim.api.nvim_set_keymap

map('n', '*', '*zz', {desc = 'Search and center screen'})

map('n', '<leader>nf', [[:NvimTreeFindFile<cr>]], {})

map('n', '<leader>l', [[:IndentLinesToggle<cr>]], {})

map('n', '<leader>t', [[:TagbarToggle<cr>]], {})

map('n', '<leader>ff', [[:Telescope find_files<cr>]], {})
map('n', '<leader>fg', [[:Telescope live_grep<cr>]], {})
map('n', '<leader>fb', [[:Telescope buffers<cr>]], {})
map('n', '<leader>fh', [[:Telescope help_tags<cr>]], {})