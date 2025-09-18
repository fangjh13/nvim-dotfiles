return {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = { -- Example mapping to toggle outline
    { "<leader>o", "<cmd>Outline<CR>",      desc = "Toggle outline" },
    { "<leader>i", "<cmd>OutlineFocus<CR>", desc = "Toggle focus between outline and code/source window" },
  },
  -- config = function()
  --   require("outline").setup {
  --   }
  -- end,
  opts = {
    outline_window = {
      position = "right",
      -- Percentage or integer of columns
      width = 18,
      -- Whether width is relative to the total width of nvim
      -- When relative_width = true, this means take `width`% of the total
      -- screen width for outline window.
      relative_width = true,
    },
  },
}
