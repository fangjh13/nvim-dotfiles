local M = {}

function M.toggle_inlay_hints(client, bufnr)
  if bufnr == nil then
    bufnr = vim.api.nvim_get_current_buf()
  end
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {
    bufnr = bufnr,
    desc = "LSP: [T]oggle Inlay [H]ints",
  })
end

local function keymappings(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Mappings: LSP
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  -- Mapping: DIAGNOSTICS
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    buf_set_keymap("n", "fmt", "<cmd>lua require('config.lsp.null-ls.utils').buf_format()<CR>", opts)
  end

  -- Toggle inlay hints in your
  -- code, if the language server you are using supports them
  if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    vim.keymap.set("n", "<leader>th", function()
      M.toggle_inlay_hints(client, bufnr)
    end)
    vim.cmd "command! LspInlayHitsToggle lua require('config.lsp.keymaps').toggle_inlay_hints()"
  end

  -- Register Whichkey
  local keymap_l = {
    { "<leader>?l",  group = "[L]SP" },
    { "<leader>?la", "<cmd>lua vim.lsp.buf.code_action()<CR>",                           desc = "Code Action [ga]" },
    { "<leader>?li", "<cmd>LspInfo<CR>",                                                 desc = "Lsp Info" },
    { "<leader>?ln", "<cmd>lua vim.lsp.buf.rename()<CR>",                                desc = "Rename [rn]" },
    { "<leader>?lr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>",       desc = "References [gr]" },
    { "<leader>?ls", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", desc = "Document Symbols" },
    { "<leader>?lL", "<cmd>lua vim.lsp.codelens.refresh()<CR>",                          desc = "Refresh CodeLens" },
    { "<leader>?ll", "<cmd>lua vim.lsp.codelens.run()<CR>",                              desc = "Run CodeLens" },
    { "<leader>?lx", "<cmd>lua require('telescope.builtin').diagnostics()<CR>",          desc = "Diagnostics" },
    {
      "<leader>?lX",
      "<cmd>lua require('config.lsp').toggle_diagnostics()<CR>",
      desc = "Toggle Inline Diagnostics",
    },
    { "<leader>?ld", "<Cmd>lua vim.lsp.buf.definition()<CR>",     desc = "Definition [gd]" },
    { "<leader>?lD", "<Cmd>lua vim.lsp.buf.declaration()<CR>",    desc = "Declaration [gD]" },
    { "<leader>?lp", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Implementation [gi]" },
    {
      "<leader>?lh",
      "<cmd>lua vim.lsp.buf.signature_help()<CR>",
      desc = "Signature Help [<C-k>]",
    },
    { "<leader>?lI", "<cmd>Telescope lsp_implementations<CR>",     desc = "Goto Implementation" },
    { "<leader>?lb", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Goto Type Definition" },
    {
      "<leader>?lq",
      "<cmd>lua vim.diagnostic.setloclist()<CR>",
      desc = "Open diagnostic [Q]uickfix list",
    },
  }

  if client.server_capabilities.documentFormattingProvider then
    table.insert(
      keymap_l,
      { "<leader>?lF", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", desc = "Format Document" }
    )
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
