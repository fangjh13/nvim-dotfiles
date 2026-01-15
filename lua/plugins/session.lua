-- [[ Session ]]
return {
  "rmagatti/auto-session",
  lazy = false,

  config = function()
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    require("auto-session").setup {
      log_level = "error",
      -- Close NvimTree before saving session
      pre_save_cmds = { "NvimTreeClose", "cclose" },
      -- Suppress session restore/create in certain directories
      suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      post_restore_cmds = {
        -- Restore project based rshada data after session is loaded
        function()
          local cwd = vim.fn.getcwd()
          local shada_name = cwd:gsub("/", "%%") .. ".shada"
          local shada_dir = vim.fn.stdpath "state" .. "/session_shada"

          if vim.fn.isdirectory(shada_dir) == 0 then
            vim.fn.mkdir(shada_dir, "p")
          end

          vim.o.shadafile = shada_dir .. "/" .. shada_name

          pcall(vim.api.nvim_command, "rshada")
        end,
      },
    }
  end,
}
