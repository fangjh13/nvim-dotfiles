local M = {}

function M.setup(client, bufnr)
  -- Set default to treesitter
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

  if client.supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
    local winid = vim.api.nvim_get_current_win()
    vim.wo[winid].foldmethod = "expr"
    vim.wo[winid].foldexpr = "v:lua.vim.lsp.foldexpr()"
  end
end

return M
