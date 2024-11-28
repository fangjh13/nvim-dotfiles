local icons = require "config.icons"

local M = {}

local function lsp_client(msg)
  msg = msg or ""
  local buf_clients = vim.lsp.get_clients {
    bufnr = vim.api.nvim_get_current_buf(),
  }
  if next(buf_clients) == nil then
    if type(msg) == "boolean" or #msg == 0 then
      return ""
    end
    return msg
  end

  local buf_ft = vim.bo.filetype
  local buf_client_names = {}

  -- add client
  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" then
      table.insert(buf_client_names, client.name)
    end
  end

  -- add formatter
  local formatters = require "config.lsp.null-ls.formatters"
  local supported_formatters = formatters.list_registered(buf_ft)
  vim.list_extend(buf_client_names, supported_formatters)

  -- add linter
  local linters = require "config.lsp.null-ls.linters"
  local supported_linters = linters.list_registered(buf_ft)
  vim.list_extend(buf_client_names, supported_linters)

  -- add hover
  local hovers = require "config.lsp.null-ls.hovers"
  local supported_hovers = hovers.list_registered(buf_ft)
  vim.list_extend(buf_client_names, supported_hovers)

  return "[" .. table.concat(buf_client_names, ", ") .. "]"
end

local function python_venv()
  local venv = require("venv-selector").venv()
  if venv ~= nil then
    local name = nil
    for word in string.gmatch(venv, "[^/]+") do
      name = word
    end
    if name ~= nil then
      venv = name
    end
    return "🐍 " .. venv
  end
  return "🐍 " .. "System"
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local custom_sections = {
  filetype = {
    "filetype",
    icon_only = true,
    padding = {
      left = 1,
      right = 0,
    },
    separator = "",
  },
  filename = {
    "filename",
    path = 0,
    padding = {
      left = 0,
      right = 1,
    },
    symbols = {
      modified = icons.git.Mod,
    },
  },
  diff = {
    "diff",
    source = diff_source(),
    symbols = {
      added = icons.git.Add .. " ",
      modified = icons.git.Mod .. " ",
      removed = icons.git.Remove .. " ",
    },
  },
}

function M.setup()
  local options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  }
  local sections = {
    lualine_b = { "branch" },
    lualine_c = { custom_sections.filetype, custom_sections.filename, custom_sections.diff },
    lualine_x = { "diagnostics" },
    lualine_y = { { lsp_client, icon = " ", color = { gui = "bold" } } },
    lualine_z = {
      { "location", icon = " " },
      { "progress" },
    },
  }
  -- show python virtual env
  table.insert(sections.lualine_x, {
    python_venv,
    cond = function()
      return vim.bo.filetype == "python"
    end,
  })
  local inactive_sections = {
    lualine_a = {},
    lualine_b = {
      custom_sections.filetype,
      custom_sections.filename,
    },
    lualine_c = {
      custom_sections.diff,
    },
    lualine_x = { "diagnostics" },
    lualine_y = { "location", "progress" },
    lualine_z = {},
  }
  require("lualine").setup {
    options = options,
    sections = sections,
    inactive_sections = inactive_sections,
    -- change statusline appearance for a window/buffer with specified filetypes
    extensions = { "quickfix", "fugitive", "nvim-tree" },
  }
end

return M
