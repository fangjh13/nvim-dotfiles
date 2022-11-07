--[[ opts.lua ]]

local o = vim.o -- For the globals options `vim.api.nvim_set_option`
local w = vim.wo -- For the window local options `vim.api.nvim_win_set_option`
local b = vim.bo -- For the buffer local options `vim.api.nvim_buf_set_option`

local cmd = vim.api.nvim_command

-- [[ Context ]]
o.colorcolumn = '80' -- str:  Show col for max line length
o.number = true -- bool: Show line numbers
o.relativenumber = true -- bool: Show relative line numbers
o.scrolloff = 4 -- int:  Min num lines of context
o.signcolumn = "yes" -- str:  Show the sign column
o.completeopt = "menu,menuone,noselect" -- str: insert mode completion

-- [[ Filetypes ]]
o.encoding = 'utf8' -- str:  String encoding to use
o.fileencoding = 'utf8' -- str:  File encoding to use

-- [[ Theme ]]
o.syntax = "ON" -- str:  Allow syntax highlighting
o.termguicolors = true -- bool: If term supports ui color then enable
cmd('colorscheme dracula') -- cmd:  Set the colorscheme


-- [[ Search ]]
o.ignorecase = true -- bool: Ignore case in search patterns
o.smartcase = true -- bool: Override ignorecase if search contains capitals
o.incsearch = true -- bool: Use incremental search
o.hlsearch = false -- bool: Highlight search matches

-- [[ Whitespace ]]
o.expandtab = true -- bool: Use spaces instead of tabs
o.shiftwidth = 4 -- num:  Size of an indent
o.softtabstop = 4 -- num:  Number of spaces tabs count for in insert mode
o.tabstop = 4 -- num:  Number of spaces tabs count for

-- [[ Splits ]]
o.splitright = true -- bool: Place new window to right of current one
o.splitbelow = true -- bool: Place new window below the current one

-- [[ Spell Check ]]
o.spell = false
o.spelllang = "en_us,cjk"
o.spellsuggest = "best,9"
