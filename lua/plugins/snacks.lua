return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    ---@class snacks.indent.Config
    indent = {
      enabled = true,
    },
    ---@class snacks.dashboard.Config
    dashboard = {
      enabled = true,
      width = 60,
      preset = {
        header = (function()
          local hour = tonumber(os.date "%H")
          local greeting
          if hour < 12 then
            greeting = "Good morning"
          elseif hour < 18 then
            greeting = "Good afternoon"
          else
            greeting = "Good evening"
          end
          local user = os.getenv "USER" or "user"
          return greeting .. ", " .. user
        end)(),
      },
      sections = {
        { section = "header", padding = 1 },
        { title = "MRU", padding = 1 },
        { section = "recent_files", limit = 8, padding = 1 },
        { title = "MRU ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
        { section = "recent_files", cwd = true, limit = 8, padding = 1 },
        { title = "Sessions", padding = 1 },
        { section = "projects", padding = 1 },
        { title = "Bookmarks", padding = 1 },
        function()
          local v = vim.version()
          local version = string.format("v%d.%d.%d", v.major, v.minor, v.patch)
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return {
            align = "center",
            text = {
              { "⚡ Neovim " .. version .. " loaded ", hl = "footer" },
              { stats.loaded .. "/" .. stats.count, hl = "special" },
              { " plugins in ", hl = "footer" },
              { ms .. "ms", hl = "special" },
            },
          }
        end,
      },
    },
  },
  keys = {
    {
      "gzi",
      function()
        Snacks.picker.lsp_incoming_calls()
      end,
      desc = "C[a]lls Incoming",
    },
    {
      "gzo",
      function()
        Snacks.picker.lsp_outgoing_calls()
      end,
      desc = "C[a]lls Outgoing",
    },
  },
}
