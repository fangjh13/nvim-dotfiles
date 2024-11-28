local M = {}

function M.list_registered_providers_names(filetype)
  local s = require "null-ls.sources"
  local available_sources = s.get_available(filetype)
  local registered = {}
  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end
  return registered
end

function M.buf_format(bufnr, timeout)
  if timeout == "" or timeout == nil then
    timeout = 3000
  end
  vim.lsp.buf.format {
    timeout_ms = timeout,
    bufnr = bufnr or vim.api.nvim_get_current_buf(),
  }
end

-- can config disable autoformat
function M.can_client_format_on_save(client)
  -- local disabled_clients = { lua_ls = 1 }
  local disabled_clients = {}
  if disabled_clients[client.name] ~= nil then
    return false
  end
  -- formatting enabled by default
  return true
end

return M
