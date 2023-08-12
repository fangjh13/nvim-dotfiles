-- [[ init.lua ]]

vim.g.mapleader = ","

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup "plugins"

vim.cmd [[
" need 'lyokha/vim-xkbswitch' installed
" mac use vim-xkbswitch enable
if has('mac')
    let g:XkbSwitchEnabled = 1
    autocmd BufEnter * let b:XkbSwitchILayout = 'us'
endif

" -------------------------------------------------------------------------------------------------
" vimspector debuger settings
" -------------------------------------------------------------------------------------------------
let g:vimspector_enable_mappings = 'HUMAN'
" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

]]
