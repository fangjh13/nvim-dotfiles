-- Utils libraries
local utils = require "utils"

-- open terminal in insert mode and enter terminal save file
utils.create_augroup({
  { "BufEnter",  "term://*", "start" },
  { "TermEnter", "*",        "wall" },
}, "open terminal auto cmd")

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  desc = "auto create folder when not exists",
  callback = function(ctx)
    local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
    vim.fn.mkdir(dir, "p")
  end,
})

-- removes all trailing whitespace from lines before saving the file
vim.api.nvim_create_autocmd("BufWritePre", {
  command = [[%s/\s\+$//e]],
  group = vim.api.nvim_create_augroup("auto_remove_trailing_whitespace", { clear = true }),
})

-- highlight yanked region, see `:h lua-highlight`
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  desc = "Highlight when yanking (copying) text",
  pattern = "*",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank { timeout = 300, on_visual = true }
  end,
})

-- go to last location of buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]],
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

-- don't auto comment new line
vim.api.nvim_create_autocmd("BufEnter", {
  command = [[set formatoptions-=cro]],
  desc = "don't auto comment new line",
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd("FocusGained", { command = [[:checktime]] })

-- use fcitx5-remote auto switching input method
if vim.fn.executable "fcitx5-remote" == 1 then
  local fcitx5_switch = function()
    vim.fn.system "fcitx5-remote -c"
  end
  vim.api.nvim_create_autocmd({ "InsertLeave", "BufCreate", "BufEnter", "BufLeave" }, {
    callback = fcitx5_switch,
    desc = "Auto-switch input method with fcitx5-remote",
  })
end

-- reopen the most recently closed buffer
vim.cmd [[
    augroup bufclosetrack
      au!
      autocmd WinLeave * let g:lastWinName = @%
    augroup END
    function! LastWindow()
      exe "vsplit " . g:lastWinName
    endfunction
    command -nargs=0 LastWindow call LastWindow()
]]
