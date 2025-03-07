local M = {}

function M.setup()
  local which_key = require "which-key"

  local conf = {
    triggers = {
      { "<leader>?", mode = "n" },
    },
  }

  which_key.setup(conf)
  which_key.add {
    { "<leader>?f", group = "[F]ind" },
    { "<leader>?ff", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "All Files" },
    { "<leader>?fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>?fh", "<cmd>Telescope help_tags<cr>", desc = "Help", icon = "󰋗" },
    { "<leader>?fo", "<cmd>Telescope oldfiles<cr>", desc = "Old Files" },
    { "<leader>?fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>?fs", "<cmd>Telescope grep_string<cr>", desc = "Find word" },
    { "<leader>?fc", "<cmd>Telescope commands<cr>", desc = "Commands", icon = "󰘳" },
    { "<leader>?fC", "<cmd>Telescope colorscheme<cr>", desc = "Color Scheme", icon = "" },
    { "<leader>?fe", "<cmd>NvimTreeFindFile<cr>", desc = "Explorer", icon = "" },

    { "<leader>?b", group = "[B]uffer" },
    { "<leader>?bc", "<Cmd>bd!<Cr>", desc = "Close current buffer" },
    { "<leader>?bD", "<Cmd>%bd|e#|bd#<Cr>", desc = "Delete all buffers" },

    { "<leader>?v", group = "[V]imspector" },
    {
      "<leader>?vG",
      "<cmd>lua require('config.vimspector').generate_debug_profile()<cr>",
      desc = "Generate Debug Profile",
    },
    { "<leader>?vI", "<cmd>VimspectorInstall<cr>",                                    desc = "Install" },
    { "<leader>?vU", "<cmd>VimspectorUpdate<cr>",                                     desc = "Update" },
    { "<leader>?vR", "<cmd>call vimspector#RunToCursor()<cr>",                        desc = "Run to Cursor" },
    { "<leader>?vc", "<cmd>call vimspector#Continue()<cr>",                           desc = "Continue" },
    { "<leader>?vi", "<cmd>call vimspector#StepInto()<cr>",                           desc = "Step Into" },
    { "<leader>?vo", "<cmd>call vimspector#StepOver()<cr>",                           desc = "Step Over" },
    { "<leader>?vs", "<cmd>call vimspector#Launch()<cr>",                             desc = "Start" },
    { "<leader>?vt", "<cmd>call vimspector#ToggleBreakpoint()<cr>",                   desc = "Toggle Breakpoint" },
    { "<leader>?vu", "<cmd>call vimspector#StepOut()<cr>",                            desc = "Step Out" },
    { "<leader>?vS", "<cmd>call vimspector#Stop()<cr>",                               desc = "Stop" },
    { "<leader>?vr", "<cmd>call vimspector#Restart()<cr>",                            desc = "Restart" },
    { "<leader>?vx", "<cmd>VimspectorReset<cr>",                                      desc = "Reset" },
    { "<leader>?vH", "<cmd>lua require('config.vimspector').toggle_human_mode()<cr>", desc = "Toggle HUMAN mode" },
  }
end

return M
