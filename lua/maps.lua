--[[ maps.lua ]]
local map = require('utils').map
local keymap = require('vim.keymap')

-- map buffer
map('n', '[b', ':bprevious <CR>', { silent = true, desc = 'buffer previous' })
map('n', ']b', ':bnext <CR>', { silent = true, desc = 'buffer next' })
map('n', '[B', ':bfirst <CR>', { silent = true, desc = 'buffer first' })
map('n', ']B', ':blast <CR>', { silent = true, desc = 'buffer last' })
-- map tabs
map('n', '[t', ':tabprevious <CR>', { silent = true, desc = 'tab previous' })
map('n', ']t', ':tabnext <CR>', { silent = true, desc = 'tab next' })
map('n', '[T', ':tabfirst <CR>', { silent = true, desc = 'tab first' })
map('n', ']T', ':tablast <CR>', { silent = true, desc = 'tab last' })
-- map quickfix list
map('n', '[c', ':cprevious <CR>', { silent = true, desc = 'quickfix previous' })
map('n', ']c', ':cnext <CR>', { silent = true, desc = 'quickfix next' })
map('n', '[C', ':cfirst <CR>', { silent = true, desc = 'quickfix first' })
map('n', ']C', ':clast <CR>', { silent = true, desc = 'quickfix last' })
map('n', '<leader>cc', ':cclose <CR>', { silent = true, desc = 'quickfix close' })
-- map location list
map('n', '[l', ':lprevious <CR>', { silent = true, desc = 'location previous' })
map('n', ']l', ':lnext <CR>', { silent = true, desc = 'location next' })
map('n', '[L', ':lfirst <CR>', { silent = true, desc = 'location first' })
map('n', ']L', ':llast <CR>', { silent = true, desc = 'location last' })
map('n', '<leader>lc', ':lclose <CR>', { silent = true, desc = 'location close' })
-- highlighting current line and set mark `l`
map('n', '<leader>ll', [[ml:execute 'match Search /\%'.line('.').'l/'<CR>]], { silent = true, desc = 'location close' })
-- open terminal in bottom
map('n', 't<Enter>', ':bo sp term://zsh|resize 5<CR>', { desc = 'open terminal in bottom' })
-- open terminal in new tab
map('n', 'T<Enter>', ':tabnew term://zsh<CR>', { desc = 'open terminal in new tab' })
-- ESC enter normal mode when in terminal
map('t', '<Esc>', [[<C-\><C-n>]], { desc = 'ESC enter normal mode when in terminal' })

map('n', '<leader>nf', [[:NvimTreeFindFile<cr>]])
map('n', '<leader>zz', [[:NvimTreeToggle<cr>]])

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
keymap.set('c', '<A-bs>', function() return '<C-w>' end, { expr = true, desc = "delete one word" })
keymap.set('c', '<C-k>', function()
    return [[<c-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>]]
    --return [[<C-\>e(" ".getcmdline())[:getcmdpos()-1][1:]<CR>]]
end, { expr = true, desc = "kill line" })
