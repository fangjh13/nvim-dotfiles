local M = {}

local icons = require "config.icons"

function M.setup()
  local function format_diagnostic(diagnostic)
    local icon = icons.error
    if diagnostic.severity == vim.diagnostic.severity.WARN then
      icon = icons.diagnostics.Warning
    elseif diagnostic.severity == vim.diagnostic.severity.INFO then
      icon = icons.diagnostics.Info
    elseif diagnostic.severity == vim.diagnostic.severity.HINT then
      icon = icons.diagnostics.Hint
    elseif diagnostic.severity == vim.diagnostic.severity.ERROR then
      icon = icons.diagnostics.Error
    end

    local message = string.format("%s %s", icon, diagnostic.message)
    if diagnostic.code and diagnostic.source then
      message = string.format("%s [%s][%s] %s", icon, diagnostic.source, diagnostic.code, diagnostic.message)
    elseif diagnostic.code or diagnostic.source then
      message = string.format("%s [%s] %s", icon, diagnostic.code or diagnostic.source, diagnostic.message)
    end

    return message .. " "
  end

  -- LSP handlers configuration
  local config = {
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
    },

    diagnostic = {
      virtual_text = {
        prefix = "",
        spacing = 2,
        source = false,
        severity = {
          min = vim.diagnostic.severity.HINT,
        },
        format = format_diagnostic,
      },

      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error .. " ",
          [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint .. " ",
          [vim.diagnostic.severity.INFO] = icons.diagnostics.Info .. " ",
          [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning .. " ",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "ErrorMsg",
          [vim.diagnostic.severity.HINT] = "DiagnosticsSignHint",
          [vim.diagnostic.severity.INFO] = "DiagnosticsSignInfo",
          [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        focusable = false,
        header = { icons.diagnostics.Debug .. " Diagnostics:", "DiagnosticInfo" },
        scope = "line",
        suffix = "",
        source = false,
        format = format_diagnostic,
      },
    },
  }

  -- Diagnostic configuration
  vim.diagnostic.config(config.diagnostic)

  -- Hover configuration
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)

  -- Signature help configuration
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end

return M
