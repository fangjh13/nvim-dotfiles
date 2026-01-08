-- pyright default on_attach
-- https://github.com/neovim/nvim-lspconfig/blob/v2.5.0/lsp/pyright.lua
local pyright_base_on_attach = vim.lsp.config.pyright and vim.lsp.config.pyright.on_attach

-- copilot default on_attach
-- https://github.com/neovim/nvim-lspconfig/blob/v2.5.0/lsp/copilot.lua
local copilot_base_on_attach = vim.lsp.config.copilot and vim.lsp.config.copilot.on_attach

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

  copilot = function(client, bufnr)
    vim.schedule(function()
      vim.lsp.inline_completion.enable()
    end)

    if copilot_base_on_attach then
      -- Add `LspCopilotSignIn` and `LspCopilotSignOut` command
      copilot_base_on_attach(client, bufnr)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
          vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

          vim.keymap.set("i", "<C-F>", function()
            -- Accept the current inline completion if available
            if not vim.lsp.inline_completion.get() then
              return "<C-F>"
            end
          end, { desc = "LSP: accept inline completion", buffer = bufnr })

          vim.keymap.set("i", "<M-]>", function()
            vim.lsp.inline_completion.select { count = 1 }
          end, { desc = "Next Copilot Suggestion", buffer = bufnr })

          vim.keymap.set("i", "<M-[>", function()
            vim.lsp.inline_completion.select { count = -1 }
          end, { desc = "Prev Copilot Suggestion", buffer = bufnr })
        end
      end,
    })
  end,
}

return M
