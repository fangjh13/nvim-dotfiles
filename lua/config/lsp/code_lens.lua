local utils = require "utils"
local M = {}

M.codelens_enabled = true

function M.toggle()
  if M.codelens_enabled then
    M.codelens_enabled = false
    vim.lsp.codelens.clear()
    utils.info "CodeLens disabled"
  else
    M.codelens_enabled = true
    vim.lsp.codelens.refresh()
    utils.info "CodeLens enabled"
  end
end

function M.setup(client, bufnr)
  if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
    if M.codelens_enabled then
      vim.lsp.codelens.refresh()
    end
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = bufnr,
      callback = function()
        if M.codelens_enabled then
          vim.lsp.codelens.refresh()
        end
      end,
    })
    -- Create a user command to call it easily
    vim.api.nvim_create_user_command("LspCodeLensToggle", M.toggle, {})
    local whichkey = prequire "which-key"
    if whichkey then
      whichkey.add {
        "<leader>?lY",
        "<cmd>lua require('config.lsp.code_lens').toggle()<CR>",
        desc = "Toggle Code Lens",
      }
    end
  end
end

return M
