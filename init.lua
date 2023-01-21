-- [[ init.lua ]]

-- Utils libraries
local utils = require "utils"

-- IMPORTS
require "vars" -- Variables
require "opts" -- Options
require "maps" -- Keymaps

require("plugins").setup() -- Plugins

utils.create_augroup({
    -- { 'BufWritePre', '*.go,*.lua,*.py', 'lua', 'vim.lsp.buf.format{ async=false }' },
    { "BufWritePre", "*.go", "lua", "go_org_imports(1000)" },
}, "lsp config")

-- open termnial in insert mode and enter termnial save file
utils.create_augroup({
    { "BufEnter", "term://*", "start" },
    { "TermEnter", "*", "wall" },
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
        vim.highlight.on_yank { timeout = 300, on_visual = false }
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
