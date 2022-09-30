--[[ maps.lua ]]
local map = require('utils').map
local keymap = require('vim.keymap')

map('n', '*', '*zz', { desc = 'Search and center screen' })

map('n', '<leader>nf', [[:NvimTreeFindFile<cr>]])

map('n', '<leader>l', [[:IndentLinesToggle<cr>]], {})

map('n', '<leader>t', [[:TagbarToggle<cr>]], {})

map('n', '<leader>ff', [[:Telescope find_files<cr>]], {})
map('n', '<leader>fg', [[:Telescope live_grep<cr>]], {})
map('n', '<leader>fb', [[:Telescope buffers<cr>]], {})
map('n', '<leader>fh', [[:Telescope help_tags<cr>]], {})

-- map %% expand current direcotry
map('c', '%%', "getcmdtype() == ':' ? expand('%:h').'/' : '%%'", { expr = true, desc = "expand current direcotry" })

-- cursor movement like termnial in command mode
keymap.set('c', '<C-a>', function() return '<Home>' end, { expr = true, desc = "cursor move to start" })
keymap.set('c', '<C-e>', function() return '<End>' end, { expr = true, desc = "cursor move to end" })
keymap.set('c', '<C-f>', function() return '<Right>' end, { expr = true, desc = "cursor move right" })
keymap.set('c', '<C-b>', function() return '<Left>' end, { expr = true, desc = "cursor move left" })
keymap.set('c', '<A-b>', function() return '<C-Left>' end, { expr = true, desc = "cursor move left one word" })
keymap.set('c', '<A-f>', function() return '<C-Right>' end, { expr = true, desc = "cursor move right one word" })
keymap.set('c', '<C-k>', function()
    return [[<c-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>]]
    --return [[<C-\>e(" ".getcmdline())[:getcmdpos()-1][1:]<CR>]]
end, { expr = true, desc = "kill line" })
