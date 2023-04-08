-- Utils libraries
local utils = require "utils"

utils.create_augroup({
  -- { 'BufWritePre', '*.go,*.lua,*.py', 'lua', 'vim.lsp.buf.format{ async=false }' },
  { "BufWritePre", "*.go", "lua", [[ require("config.lsp").go_org_imports(1000) ]] },
}, "lsp config")

-- open termnial in insert mode and enter termnial save file
utils.create_augroup({
  { "BufEnter",  "term://*", "start" },
  { "TermEnter", "*",        "wall" },
}, "open termnial auto cmd")

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  desc = "auto create folder when not exists",
  callback = function(ctx)
    local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
    vim.fn.mkdir(dir, "p")
  end,
})

-- highlight yanked region, see `:h lua-highlight`
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
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
-- vim.api.nvim_create_autocmd("BufEnter", {
--   command = [[set formatoptions-=cro]],
--   desc = "don't auto comment new line",
-- })

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd("FocusGained", { command = [[:checktime]] })
