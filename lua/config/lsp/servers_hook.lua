-- [[ This module provides custom `on_attach` functions (LspAttach Event Autocommands) for specific LSP servers. ]] --

-- pyright default on_attach
-- https://github.com/neovim/nvim-lspconfig/blob/v2.5.0/lsp/pyright.lua
local pyright_base_on_attach = vim.lsp.config.pyright and vim.lsp.config.pyright.on_attach

-- eslint default on_attach
-- https://github.com/neovim/nvim-lspconfig/blob/v2.5.0/lsp/eslint.lua
local eslint_base_on_attach = vim.lsp.config.eslint and vim.lsp.config.eslint.on_attach

-- rust_analyzer default on_attach
-- https://github.com/neovim/nvim-lspconfig/blob/v2.5.0/lsp/rust_analyzer.lua#L116
local rust_analyzer_base_on_attach = vim.lsp.config.rust_analyzer and vim.lsp.config.rust_analyzer.on_attach

local M = {
  ruff = function(client, bufnr)
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end,

  pyright = function(client, bufnr)
    if pyright_base_on_attach then
      -- Add `LspPyrightOrganizeImports` and `LspPyrightSetPythonPath` command
      pyright_base_on_attach(client, bufnr)
    end
  end,

  rust_analyzer = function(client, bufnr)
    -- Rust project enable Inlay Hints default
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

    -- Add `:LspCargoReload` command
    if rust_analyzer_base_on_attach then
      rust_analyzer_base_on_attach(client, bufnr)
    end
  end,

  clangd = function(client, bufnr)
    -- Enable clangd extensions
    require("clangd_extensions").setup {}
  end,

  eslint = function(client, bufnr)
    if eslint_base_on_attach then
      -- Add `LspEslintFixAll` command
      eslint_base_on_attach(client, bufnr)
    end
    -- Auto-fix ESLint issues on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "LspEslintFixAll",
    })
  end,
}

return M
