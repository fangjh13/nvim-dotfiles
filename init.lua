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
" use fcitx5-remote auto switching input method
if executable('fcitx5-remote')
    autocmd InsertLeave * :silent !fcitx5-remote -c
    autocmd BufCreate *  :silent !fcitx5-remote -c
    autocmd BufEnter *  :silent !fcitx5-remote -c
    autocmd BufLeave *  :silent !fcitx5-remote -c
endif

" -------------------------------------------------------------------------------------------------
" vimspector debuger settings
" -------------------------------------------------------------------------------------------------
let g:vimspector_enable_mappings = 'HUMAN'
" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

" reopen the most recently closed buffer
augroup bufclosetrack
  au!
  autocmd WinLeave * let g:lastWinName = @%
augroup END
function! LastWindow()
  exe "vsplit " . g:lastWinName
endfunction
command -nargs=0 LastWindow call LastWindow()

]]
