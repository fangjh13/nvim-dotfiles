--[[ defaults.lua ]]
local o = vim.opt -- For the globals options `vim.api.nvim_set_option`
local g = vim.g -- Set global variables. `vim.api.nvim_set_var`
local w = vim.wo -- For the window local options `vim.api.nvim_win_set_option`
local b = vim.bo -- For the buffer local options `vim.api.nvim_buf_set_option`

-- [[ LEADER ]]
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
g.mapleader = ","
g.localleader = "\\"

g.t_co = 256
g.background = "dark"
g.vimsyn_embed = "lPr" -- Syntax embedding for Lua, Python and Ruby

-- [[ Context ]]
o.colorcolumn = "80" -- str:  Show col for max line length
o.number = true -- bool: Show line numbers
o.relativenumber = true -- bool: Relative line numbers
o.scrolloff = 4 -- int:  Min num lines of context
o.signcolumn = "yes" -- str:  Show the sign column
o.completeopt = "menu,menuone,noselect" -- str: insert mode completion
o.cpoptions:append ">" -- when appending to a register, put a line break before the appended text.
o.listchars = "eol:⏎,tab:␉·,trail:␠,nbsp:⎵,extends:»,precedes:«"

-- [[ Filetypes ]]
o.encoding = "utf8" -- str:  String encoding to use
o.fileencoding = "utf8" -- str:  File encoding to use

-- [[ Search ]]
o.ignorecase = true -- bool: Ignore case in search patterns
o.wildignorecase = true -- bool: Ignore case in search file names and directories.
o.wildignore:append "**/.git/*"
o.smartcase = true -- bool: Override ignorecase if search contains capitals
o.incsearch = true -- bool: Use incremental search
o.hlsearch = true -- bool: Highlight search matches

-- [[ Better search ]]
o.path:remove "/usr/include"
o.path:append "**"
-- vim.cmd [[set path=.,,,$PWD/**]] -- Set the path directly

-- [[ Whitespace ]]
o.expandtab = true -- bool: Use spaces instead of tabs
o.smarttab = true -- bool: inserts blanks according to `shiftwidth`.
o.shiftwidth = 2 -- num:  Size of an indent
o.tabstop = 2 -- num:  Number of spaces tabs count for
o.softtabstop = 2 -- num:  Number of spaces tabs count for in insert mode
o.textwidth = 0 -- num:  Maximum width of text that is being inserted.

-- [[ Indent ]]
o.autoindent = true -- bool: Auto insert indent
o.breakindent = true -- bool: Enable break indent
o.smartindent = true -- bool: Smart indent

-- [[ Terminal ]]
o.scrollback = 100000

-- [[ Splits ]]
o.splitright = true -- bool: Place new window to right of current one
o.splitbelow = true -- bool: Place new window below the current one

-- [[ Edit ]]
o.undofile = true -- bool: Save undo history
o.updatetime = 1000 -- num: Decrease write to disk
o.scrolloff = 8 -- Lines of context
-- o.clipboard = "unnamedplus" -- str: uses the clipboard register "+"
o.inccommand = "split" -- preview substitutions live, as you type

-- [[ Theme ]]
o.termguicolors = true -- bool: If term supports ui color then enable
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- [[ Spell Check ]]
o.spell = false
o.spelllang = "en_us,cjk"
o.spellsuggest = "best,9"

-- [[ Path ]]
o.path:remove "/usr/include"
o.path:append "**"

-- Time in milliseconds to wait for a mapped sequence to complete.
o.timeoutlen = 900

-- Set the fold level to a high number to open all folds by default
o.foldlevel = 99
o.foldlevelstart = 99
