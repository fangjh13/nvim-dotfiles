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

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*",
    group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
    desc = "auto create folder when not exists",
    callback = function(ctx)
        local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
        vim.fn.mkdir(dir, "p")
    end
})

-- highlight yanked region, see `:h lua-highlight`
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    pattern = "*",
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank { timeout = 300, on_visual = false }
    end
})

-- show cursor line only in active window
local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd(
    { "InsertLeave", "WinEnter", "BufWinEnter" },
    { pattern = "*", command = "setlocal cursorline", group = cursorGrp }
)
vim.api.nvim_create_autocmd(
    { "InsertEnter", "WinLeave" },
    { pattern = "*", command = "setlocal nocursorline", group = cursorGrp }
)
