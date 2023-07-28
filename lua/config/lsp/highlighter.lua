local M = {}

local utils = require "utils"

M.highlight = true

function M.toggle()
  M.highlight = not M.highlight
  if M.highlight then
    utils.info("Enabled document highlight", "Document Highlight")
  else
    utils.warn("Disabled document highlight", "Document Highlight")
  end
end

function M.highlight(client)
  -- Set autocommands conditional on server_capabilities
  -- highlight the current variable and its usages in the buffer.
  if M.highlight then
    if client.server_capabilities.documentHighlightProvider then
      local present, illuminate = pcall(require, "illuminate")
      if present then
        illuminate.on_attach(client)
      else
        vim.api.nvim_exec(
          [[
            " hi LspReferenceRead cterm=bold ctermbg=DarkMagenta guibg=LightYellow
            " hi LspReferenceText cterm=bold ctermbg=DarkMagenta guibg=LightYellow
            " hi LspReferenceWrite cterm=bold ctermbg=DarkMagenta guibg=LightYellow
            augroup lsp_document_highlight
              autocmd! * <buffer>
              " 光标不动时高亮变量名
              autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
              autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
              " 移动光标时清除高亮
              autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
              autocmd CursorMoveI <buffer> lua vim.lsp.buf.clear_references()
              " 输入时显示函数签名提示
              " autocmd TextChangedI <buffer> lua vim.lsp.buf.signature_help()
              " autocmd TextChangedP <buffer> lua vim.lsp.buf.signature_help()
            augroup END
          ]],
          false
        )
      end
    end
  end
end

function M.setup(client)
  M.highlight(client)
end

return M
