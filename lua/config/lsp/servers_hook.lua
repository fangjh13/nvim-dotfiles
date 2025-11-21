local n_utils = require "config.lsp.null-ls.utils"
local n_formatters = require "config.lsp.null-ls.formatters"

local M = {
  pyright = function(client, bufnr)
    -- Add keybinds
    require("utils").map_buf(
      "n",
      "<leader>lo",
      "<cmd>PyrightOrganizeImports<cr>",
      { silent = true, desc = "Organize Imports", noremap = true },
      bufnr
    )
    -- Add auto organize imports
    if n_utils.can_client_format_on_save(client) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        group = n_formatters.augroup,
        callback = function()
          vim.lsp.buf.code_action {
            context = { only = { "source.organizeImports" } },
            apply = true,
          }
          -- https://github.com/astral-sh/ruff-lsp/issues/95
          vim.wait(100)
        end,
      })
    end

    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end,
  gopls = function(client, bufnr)
    if n_utils.can_client_format_on_save(client) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        group = n_formatters.augroup,
        callback = function()
          require("config.lsp.null-ls.formatters").go_org_imports()
          vim.wait(100)
        end,
      })
    end
  end,
}

return M
