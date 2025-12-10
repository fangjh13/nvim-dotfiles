return {
  "folke/snacks.nvim",
  opts = {
    ---@class snacks.indent.Config
    indent = {
      enabled = true,
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
