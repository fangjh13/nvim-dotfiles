--[[ init.lua ]]

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = ","
vim.g.localleader = "\\"

-- Update the packpath
local packer_path = vim.fn.stdpath('config') .. '/site'
vim.o.packpath = vim.o.packpath .. ',' .. packer_path


-- Utils libraries
local utils = require('utils')

-- IMPORTS
require('plugins') -- Plugins
require('vars') -- Variables
require('opts') -- Options
require('maps') -- Keymaps


-- PLUGINS setup
require("nvim_cmp_config")
require('lsp_config')
require("lualine_config")
require("treesitter_config")

utils.create_augroup({
    { 'BufWritePre', '*.go,*.lua', 'lua', 'vim.lsp.buf.format()' },
    { 'BufWritePre', '*.go', 'lua', 'go_org_imports(1000)' }
}, 'lsp config')
