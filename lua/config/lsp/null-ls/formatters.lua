local M = {}

local utils = require "utils"
local nls_utils = require "config.lsp.null-ls.utils"
local nls_sources = require "null-ls.sources"
local api = vim.api

local method = require("null-ls").methods.FORMATTING

M.autoformat = false
M.augroup = vim.api.nvim_create_augroup("LspFormat", { clear = true })

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
  local filetype = api.nvim_get_option_value("filetype", { buf = bufnr })

  if client.server_capabilities.documentFormattingProvider then
    M.autoformat = true
  end

  -- try use null-ls
  if not M.autoformat then
    if M.has_formatter(filetype) then
      M.autoformat = client.name == "null-ls"
    end
  end

  if not M.autoformat then
    return
  end

  client.server_capabilities.documentFormattingProvder = M.autoformat
  client.server_capabilities.documentRangeFormattingProvider = M.autoformat
  if client.server_capabilities.documentFormattingProvider then
    -- register LspFormat command can format manual
    vim.cmd(
      string.format(
        "command! -nargs=? LspFormat lua require('config.lsp.null-ls.utils').buf_format(%s, <q-args>)",
        bufnr
      )
    )
    -- register LspFormatToggle command can format manual
    vim.cmd "command! LspFormatToggle lua require('config.lsp.null-ls.formatters').toggle()"
    -- set up auto format on save
    vim.api.nvim_clear_autocmds {
      group = M.augroup,
      buffer = bufnr,
    }
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        if M.autoformat then
          vim.lsp.buf.format {
            timeout_ms = 3000,
            bufnr = bufnr,
            filter = function()
              return nls_utils.can_client_format_on_save(client)
            end,
          }
        end
      end,
      buffer = bufnr,
      group = M.augroup,
    })
  end
end

function M.has_formatter(filetype)
  local available = nls_sources.get_available(filetype, method)
  return #available > 0
end

function M.list_registered(filetype)
  local registered_providers = nls_utils.list_registered_providers_names(filetype)
  return registered_providers[method] or {}
end

function M.list_supported(filetype)
  local supported_formatters = nls_sources.get_supported(filetype, "formatting")
  table.sort(supported_formatters)
  return supported_formatters
end

-- Go auto imports
function M.go_org_imports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
        vim.lsp.util.apply_workspace_edit(r.edit, enc)
      end
    end
  end
end

return M
