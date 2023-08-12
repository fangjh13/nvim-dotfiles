-- [[ Debug ]]

return {
  "puremourning/vimspector",
  cmd = { "VimspectorInstall", "VimspectorUpdate" },
  fn = { "vimspector#Launch()", "vimspector#ToggleBreakpoint", "vimspector#Continue" },
  config = function()
    require("config.vimspector").setup()
  end,
}
