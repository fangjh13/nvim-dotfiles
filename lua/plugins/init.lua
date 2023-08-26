local plugins = {}

-- [[ Switch Keyboard Layout ]]
if vim.fn.has "mac" == 1 then
  local t = {
    "laishulu/vim-macos-ime",
    config = function()
      vim.g.macosime_normal_ime = "com.apple.keylayout.ABC"
      vim.g.macosime_cjk_ime = "com.sogou.inputmethod.sogou.pinyin"
    end,
  }
  table.insert(plugins, t)
end

return plugins
