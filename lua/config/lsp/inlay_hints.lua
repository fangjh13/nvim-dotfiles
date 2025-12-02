local M = {}

function M.toggle_inlay_hints(client, bufnr)
  if bufnr == nil then
    bufnr = vim.api.nvim_get_current_buf()
  end
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {
    bufnr = bufnr,
    desc = "LSP: Toggle Inlay Hints",
  })
  utils.info("Inlay Hints: " .. tostring(vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }))
end

return M
