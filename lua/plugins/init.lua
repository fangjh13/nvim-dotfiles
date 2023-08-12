local plugins = {}

-- [[ Switch Keyboard Layout ]]
if vim.fn.has "mac" == 1 then
  local t = { "lyokha/vim-xkbswitch" }
  table.insert(plugins, t)
end

return plugins
