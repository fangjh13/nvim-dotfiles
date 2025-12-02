local M = {
  ruff = function(client, bufnr)
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end,

  pyright = function(client, bufnr)
    -- Add keybinds
    require("utils").map_buf(
      "n",
      "<leader>lo",
      "<cmd>PyrightOrganizeImports<cr>",
      { silent = true, desc = "Organize Imports", noremap = true },
      bufnr
    )
  end,

  rust_analyzer = function(client, bufnr)
    -- Rust project enable Inlay Hints default
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end,
}

return M
