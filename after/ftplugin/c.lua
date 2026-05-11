-- Google C++ Style (also applies to C): 2-space indentation, 80 columns
-- https://google.github.io/styleguide/cppguide.html

vim.bo.shiftwidth = 2 -- indent with 2 spaces
vim.bo.tabstop = 2 -- display tab as 2 spaces
vim.bo.softtabstop = 2 -- insert 2 spaces on <Tab>
vim.bo.expandtab = true -- use spaces instead of tabs
vim.bo.textwidth = 80 -- line length limit
vim.bo.autoindent = true -- copy indent from current line
vim.bo.smartindent = true -- smart auto-indent for C-like languages

-- C indent options (:help cinoptions-values)
-- NOTE: only effective when treesitter indent is disabled for c.
-- To use cinoptions, add `c = true` to `indent_disabled` in treesitter.lua.
--
--   g1   — indent access specifiers (public/private/protected) by 1 char
--   h1   — indent statements after access specifier by 1 char relative to it
--   N-s  — do NOT indent inside namespace blocks
--   E-s  — do NOT indent inside extern "C" blocks
--   i2s  — indent C++ base class declarations and constructor initializers by 2×shiftwidth
--   +2s  — indent continuation lines by 2×shiftwidth
--   (0   — align to first non-whitespace char after unclosed parenthesis
--   u0   — same as above for deeper nesting levels
--   U1   — do not ignore chars on the line with the unclosed paren
--   w1   — align with the char right after the unclosed paren
--   W2s  — indent 2×shiftwidth if unclosed paren is last char on its line
--   j1   — indent Java anonymous classes correctly
--   J1   — indent JavaScript object declarations correctly
vim.bo.cinoptions = "g1,h1,N-s,E-s,i2s,+2s,(0,u0,U1,w1,W2s,j1,J1"

-- Use C++ style line comments
vim.bo.commentstring = "// %s"
