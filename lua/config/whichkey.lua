local M = {}

function M.setup()
  local which_key = require "which-key"

  local conf = {
    window = {
      border = "single",         -- none, single, double, shadow
      position = "bottom",       -- bottom, top
    },
    plugins = {
      marks = false,           -- shows a list of your marks on ' and `
      registers = false,       -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      spelling = {
        enabled = true,           -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20,         -- how many suggestions should be shown in the list?
      },
      presets = {
        operators = false,            -- adds help for operators like d, y, ...
        motions = false,              -- adds help for motions
        text_objects = false,         -- help for text objects triggered after entering an operator
        windows = false,              -- default bindings on <c-w>
        nav = false,                  -- misc bindings to work with windows
        z = true,                     -- bindings for folds, spelling and others prefixed with z
        g = false,                    -- bindings for prefixed with g
      },
    },
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      -- this is mostly relevant for keymaps that start with a native binding
      n = { "]", "[", "<leader>", "c", "f", "F", "y", "d", "g", "t", "T", "gc", "gb", "ys" },
      i = { "j", "k" },
      v = { "j", "k" },
    },
  }

  local opts = {
    mode = "n",         -- Normal mode
    prefix = " ",       -- Space
    buffer = nil,       -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,      -- use `silent` when creating keymaps
    noremap = true,     -- use `noremap` when creating keymaps
    nowait = false,     -- use `nowait` when creating keymaps
  }

  local mappings = {
    ["w"] = { "<cmd>update!<CR>", "Save" },
    ["q"] = { "<cmd>q!<CR>", "Quit" },
    ["t"] = { "<cmd>TagbarToggle<CR>", "Tagbar" },
    f = {
      name = "Find",
      f = { "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", "AllFiles" },
      b = { "<cmd>Telescope buffers<cr>", "Buffers" },
      h = { "<cmd>Telescope help_tags<cr>", "Help" },
      o = { "<cmd>Telescope oldfiles<cr>", "Old Files" },
      g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
      s = { "<cmd>Telescope grep_string<cr>", "Find word" },
      c = { "<cmd>Telescope commands<cr>", "Commands" },
      C = { "<cmd>Telescope colorscheme<cr>", "Color Scheme" },
      e = { "<cmd>NvimTreeFindFile<cr>", "Explorer" },
    },
    b = {
      name = "Buffer",
      c = { "<Cmd>bd!<Cr>", "Close current buffer" },
      D = { "<Cmd>%bd|e#|bd#<Cr>", "Delete all buffers" },
    },
    z = {
      name = "Packer",
      c = { "<cmd>PackerCompile<cr>", "Compile" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      s = { "<cmd>PackerSync<cr>", "Sync" },
      S = { "<cmd>PackerStatus<cr>", "Status" },
      u = { "<cmd>PackerUpdate<cr>", "Update" },
    },
    v = {
      name = "Vimspector",
      G = { "<cmd>lua require('config.vimspector').generate_debug_profile()<cr>", "Generate Debug Profile" },
      I = { "<cmd>VimspectorInstall<cr>", "Install" },
      U = { "<cmd>VimspectorUpdate<cr>", "Update" },
      R = { "<cmd>call vimspector#RunToCursor()<cr>", "Run to Cursor" },
      c = { "<cmd>call vimspector#Continue()<cr>", "Continue" },
      i = { "<cmd>call vimspector#StepInto()<cr>", "Step Into" },
      o = { "<cmd>call vimspector#StepOver()<cr>", "Step Over" },
      s = { "<cmd>call vimspector#Launch()<cr>", "Start" },
      t = { "<cmd>call vimspector#ToggleBreakpoint()<cr>", "Toggle Breakpoint" },
      u = { "<cmd>call vimspector#StepOut()<cr>", "Step Out" },
      S = { "<cmd>call vimspector#Stop()<cr>", "Stop" },
      r = { "<cmd>call vimspector#Restart()<cr>", "Restart" },
      x = { "<cmd>VimspectorReset<cr>", "Reset" },
      H = { "<cmd>lua require('config.vimspector').toggle_human_mode()<cr>", "Toggle HUMAN mode" },
    },
  }

  which_key.setup(conf)
  which_key.register(mappings, opts)
end

return M
