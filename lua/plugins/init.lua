local plugins = {}

-- [[ Switch Keyboard Layout ]]
-- NOTE: Install `macism` first, https://github.com/laishulu/vim-macos-ime
if vim.fn.has "mac" == 1 then
  local t = {
    "laishulu/vim-macos-ime",
    config = function()
      vim.g.macosime_normal_ime = "com.apple.keylayout.ABC"
      vim.g.macosime_cjk_ime = "im.rime.inputmethod.Squirrel.Hans" -- 鼠鬚管
    end,
  }
  table.insert(plugins, t)
end

return plugins
