local utils = require "utils"
local M = {}

local function keymappings(client, bufnr)
  local float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
  }

  -- Mappings: LSP
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { noremap = true, silent = true }
  utils.map_buf_lua_str("n", "gD", "vim.lsp.buf.declaration()", opts, bufnr)
  utils.map_buf_lua_str("n", "gd", "vim.lsp.buf.definition()", opts, bufnr)
  utils.map_buf_lua_str("n", "gy", "vim.lsp.buf.type_definition()", opts, bufnr)
  utils.map_buf_lua_str("n", "ga", "vim.lsp.buf.code_action()", opts, bufnr)
  -- Hover configuration
  utils.map_lua_buf("n", "K", function()
    vim.lsp.buf.hover(float)
  end, opts, bufnr)
  -- Signature help configuration
  utils.map_lua_buf("n", "gK", function()
    vim.lsp.buf.signature_help(float)
  end, opts, bufnr)
  utils.map_lua_buf("i", "<C-k>", function()
    vim.lsp.buf.signature_help(float)
  end, opts, bufnr)
  utils.map_buf_lua_str("n", "gi", "vim.lsp.buf.implementation()", opts, bufnr)
  utils.map_buf_lua_str("n", "gr", "vim.lsp.buf.references()", opts, bufnr)
  utils.map_buf_lua_str("n", "<space>wa", "vim.lsp.buf.add_workspace_folder()", opts, bufnr)
  utils.map_buf_lua_str("n", "<space>wr", "vim.lsp.buf.remove_workspace_folder()", opts, bufnr)
  utils.map_buf_lua_str("n", "<space>wl", "print(vim.inspect(vim.lsp.buf.list_workspace_folders()))", opts, bufnr)
  utils.map_buf_lua_str("n", "<space>rn", "nim.lsp.buf.rename()", opts, bufnr)
  -- Mapping: DIAGNOSTICS
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  utils.map_buf_lua_str("n", "<space>e", "vim.diagnostic.open_float()", opts, bufnr)
  utils.map_buf_lua_str("n", "[d", "vim.diagnostic.goto_prev()", opts, bufnr)
  utils.map_buf_lua_str("n", "]d", "vim.diagnostic.goto_next()", opts, bufnr)
  utils.map_buf_lua_str("n", "<space>q", "vim.diagnostic.setloclist()", opts, bufnr)

  -- Register Whichkey
  local keymap_l = {
    { "<leader>?l", group = "[L]SP" },
    { "<leader>?la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action [ga]" },
    { "<leader>?li", "<cmd>LspInfo<CR>", desc = "Lsp Info" },
    { "<leader>?ln", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename [rn]" },
    { "<leader>?lr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", desc = "References [gr]" },
    { "<leader>?ls", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", desc = "Document Symbols" },
    { "<leader>?lL", "<cmd>lua vim.lsp.codelens.refresh()<CR>", desc = "Refresh CodeLens" },
    { "<leader>?ll", "<cmd>lua vim.lsp.codelens.run()<CR>", desc = "Run CodeLens" },
    { "<leader>?lx", "<cmd>lua require('telescope.builtin').diagnostics()<CR>", desc = "Diagnostics" },
    {
      "<leader>?lX",
      "<cmd>lua require('config.lsp.diagnostic').toggle_diagnostics()<CR>",
      desc = "Toggle Diagnostics",
    },
    { "<leader>?ld", "<Cmd>lua vim.lsp.buf.definition()<CR>", desc = "Definition [gd]" },
    { "<leader>?lD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Declaration [gD]" },
    { "<leader>?lp", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Implementation [gi]" },
    {
      "<leader>?lh",
      "<cmd>lua vim.lsp.buf.signature_help()<CR>",
      desc = "Signature Help",
    },
    { "<leader>?lI", "<cmd>Telescope lsp_implementations<CR>", desc = "Goto Implementation" },
    { "<leader>?lb", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Goto T[y]pe Definition" },
    {
      "<leader>?lq",
      "<cmd>lua vim.diagnostic.setloclist()<CR>",
      desc = "Open diagnostic [Q]uickfix list",
    },
  }
  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    utils.map_buf_lua_str("n", "fmt", "require('config.lsp.format').buf_format()", opts, bufnr)
    table.insert(
      keymap_l,
      { "<leader>?lF", "<cmd>lua require('config.lsp.format').buf_format()<CR>", desc = "Format Document" }
    )
  end

  -- Toggle inlay hints in your
  -- code, if the language server you are using supports them
  if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    vim.keymap.set("n", "<leader>th", function()
      require("config.lsp.inlay_hints").toggle_inlay_hints(client, bufnr)
    end)
    vim.cmd "command! LspInlayHitsToggle lua require('config.lsp.inlay_hints').toggle_inlay_hints()"
    table.insert(keymap_l, {
      "<leader>?ly",
      "<cmd>lua require('config.lsp.inlay_hints').toggle_inlay_hints()<CR>",
      desc = "Toggle Inlay Hints",
    })
  end

  local whichkey = prequire "which-key"
  if whichkey then
    whichkey.add(keymap_l)
  end
end

function M.setup(client, bufnr)
  keymappings(client, bufnr)
end

return M
