local M = {}

local utils = require "utils"

M.highlightOpen = true

function M.toggle()
  M.highlightOpen = not M.highlightOpen
  if M.highlightOpen then
    utils.info("Enabled document highlight", "Document Highlight")
  else
    utils.warn("Disabled document highlight", "Document Highlight")
  end
end

function M.highlight(client, bufnr)
  -- Set autocommands conditional on server_capabilities
  -- highlight the current variable and its usages in the buffer.
  if M.highlightOpen then
    if client.server_capabilities.documentHighlightProvider then
      local present, illuminate = pcall(require, "illuminate")
      if present then
        illuminate.on_attach(client)
      else
        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = event2.buf }
            end,
          })
        end
      end
    end
  end
end

function M.setup(client, bufnr)
  M.highlight(client, bufnr)
end

return M
