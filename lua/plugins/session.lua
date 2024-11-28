-- [[ Session ]]
return {
  "rmagatti/auto-session",
  lazy = false,

  config = function()
    require("auto-session").setup {
      log_level = "error",
      -- Close NvimTree before saving session
      pre_save_cmds = { "NvimTreeClose", "cclose" },
      -- Suppress session restore/create in certain directories
      suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    }
  end,
}
