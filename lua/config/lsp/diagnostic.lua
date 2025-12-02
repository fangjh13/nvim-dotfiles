local M = {}

local icons = require "config.icons"

local diagnostics_active = true

function M.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

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

    local message = string.format("%s  %s", icon, diagnostic.message)
    return message .. " "
  end

  local config = {
    diagnostic = {
      virtual_text = {
        prefix = "",
        spacing = 4,
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
        source = "if_many",
      },
    },
  }

  -- Diagnostic configuration
  vim.diagnostic.config(config.diagnostic)
end

function M.autocmd(client, bufnr)
  -- display diagnostic in floating window on CursorHold
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "CursorMoved", "InsertEnter" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "cursor",
      }
      vim.diagnostic.open_float(nil, opts)
    end,
    desc = "Display diagnostic window on CursorHold",
  })
end

return M
