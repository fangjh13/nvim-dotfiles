-- [[ init.lua ]]

if vim.fn.has "nvim-0.10" == 0 then
  error "Need Neovim v0.10+ to run!"
end

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require "config.lazy"
