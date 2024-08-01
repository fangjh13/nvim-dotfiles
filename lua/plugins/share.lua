return {
  "krivahtoo/silicon.nvim",
  build = "./install.sh",
  config = function()
    require("silicon").setup {
      font = "Hack Nerd Font=26",
      -- font = "HarmonyOS Sans SC=26", -- 支持中文
      background = "#87f",
      theme = "Monokai Extended",
      watermark = {
        text = "@Fython",
      },
      line_number = true,
      pad_vert = 80,
      pad_horiz = 50,
      window_title = function()
        return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ":~:.")
      end,
    }
  end,
}
