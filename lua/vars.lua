--[[ vars.lua ]]

local g = vim.g -- Set global variables. `vim.api.nvim_set_var`

g.t_co = 256
g.background = "dark"
g.python3_host_prog = '~/.pyenv/versions/py310/bin/python'

-- disable netrw use nvim-tree instead
g.loaded = 1
g.loaded_netrwPlugin = 1
