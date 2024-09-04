local M = {}

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
    buf_set_keymap("n", "fmt", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
  end

  -- Toggle inlay hints in your
  -- code, if the language server you are using supports them
  if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    vim.keymap.set("n", "<leader>th", function()
      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr, desc = "LSP: [T]oggle Inlay [H]ints" }
      )
    end)
  end

  -- Register Whichkey
  local keymap_l = {
    l = {
      name = "LSP",
      a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action [ga]" },
      i = { "<cmd>LspInfo<CR>", "Lsp Info" },
      n = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename [rn]" },
      r = { "<cmd>lua require('telescope.builtin').lsp_references()<CR>", "References [gr]" },
      s = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", "Document Symbols" },
      L = { "<cmd>lua vim.lsp.codelens.refresh()<CR>", "Refresh CodeLens" },
      l = { "<cmd>lua vim.lsp.codelens.run()<CR>", "Run CodeLens" },
      x = { "<cmd>lua require('telescope.builtin').diagnostics()<CR>", "Diagnostics" },
      X = { "<cmd>lua require('config.lsp').toggle_diagnostics()<CR>", "Toggle Inline Diagnostics" },
      d = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Definition [gd]" },
      D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration [gD]" },
      p = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation [gi]" },
      h = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help [<C-k>]" },
      I = { "<cmd>Telescope lsp_implementations<CR>", "Goto Implementation" },
      b = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
      q = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Open diagnostic [Q]uickfix list" },
    },
  }
  if client.server_capabilities.documentFormattingProvider then
    keymap_l.l.F = { "<cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format Document" }
  end

  local whichkey = prequire "which-key"
  if whichkey then
    local keymap_v_l = {
      l = {
        name = "LSP",
        a = { "<cmd>'<,'>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
      },
    }

    local o = { buffer = bufnr, prefix = " " }
    whichkey.register(keymap_l, o)

    o = { mode = "v", buffer = bufnr, prefix = " " }
    whichkey.register(keymap_v_l, o)
  end
end

function M.setup(client, bufnr)
  keymappings(client, bufnr)
end

return M
