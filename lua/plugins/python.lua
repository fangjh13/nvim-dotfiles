return {
  "linux-cultist/venv-selector.nvim",
  lazy = true,
  cmd = "VenvSelect",
  branch = "regexp", -- This is the regexp branch, use this for the new version
  config = function()
    require("venv-selector").setup()
  end,
  keys = {
    -- Keymap to open VenvSelector to pick a venv.
    { "<leader>vs", "<cmd>VenvSelect<cr>" },
    -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
    { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
  },
}
