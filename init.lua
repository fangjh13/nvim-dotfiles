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
require('plugins')   -- Plugins
require('vars')      -- Variables
require('opts')      -- Options
require('keys')      -- Keymaps


-- PLUGINS setup
require('lsp_config')
require("lualine_config")
require("nvim_cmp_config")

utils.create_augroup({
    {'BufWritePre', '*.go', 'lua', 'vim.lsp.buf.formatting()'},
    {'BufWritePre', '*.go', 'lua', 'goimports(1000)'}
}, 'go lsp')
