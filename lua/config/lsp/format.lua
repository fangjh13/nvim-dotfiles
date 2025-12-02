M = {}

M.augroup = vim.api.nvim_create_augroup("LspFormat", { clear = true })

M.autoformat = false

local conform_present, conform = pcall(require, "conform")

-- toggle auto format on save file
function M.toggle()
  M.autoformat = not M.autoformat
  if M.autoformat then
    utils.info("Enabled format on save", "Formatting")
  else
    utils.warn("Disabled format on save", "Formatting")
  end
end

function M.setup(client, bufnr)
  if conform_present then
    M.autoformat = true
  elseif client.server_capabilities.documentFormattingProvider then
    M.autoformat = true
  end

  if not M.autoformat then
    return
  end

  -- register LspFormatToggle command can format manual
  vim.cmd "command! LspFormatToggle lua require('config.lsp.format').toggle()"
  -- set up auto format on save
  vim.api.nvim_clear_autocmds {
    group = M.augroup,
    buffer = bufnr,
  }
  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
      if M.autoformat then
        M.buf_format(bufnr)
      end
    end,
    buffer = bufnr,
    group = M.augroup,
  })
end

function M.buf_format(bufnr, timeout)
  if timeout == "" or timeout == nil then
    timeout = 3000
  end
  if conform_present then
    conform.format()
    return
  end
  -- lsp format
  vim.lsp.buf.format {
    timeout_ms = timeout,
    bufnr = bufnr or vim.api.nvim_get_current_buf(),
  }
end

return M
