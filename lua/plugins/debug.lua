-- [[ Debug ]]

return {
  "puremourning/vimspector",
  cmd = { "VimspectorInstall", "VimspectorUpdate", "VimspectorLaunch" },
  config = function()
    require("config.vimspector").setup()
  end,
  init = function()
    vim.g.vimspector_enable_mappings = "HUMAN"
  end,
}
