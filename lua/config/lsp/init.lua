local M = {}

local servers = {
  gopls = {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        semanticTokens = true,
      },
    },
  },
  html = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    },
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        },
      },
    },
  },
  -- pylsp = {}, -- Integration with rope for refactoring - https://github.com/python-rope/pylsp-rope
  -- rust_analyzer = {
  --   settings = {
  --     ["rust-analyzer"] = {
  --       cargo = { allFeatures = true },
  --       checkOnSave = {
  --         command = "cargo clippy",
  --         extraArgs = { "--no-deps" },
  --       },
  --     },
  --   },
  -- },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins", "MiniTest" },
          -- disable = { "lowercase-global", "undefined-global", "unused-local", "unused-vararg", "trailing-space" },
        },
        workspace = {
          checkThirdParty = false,
        },
        completion = { callSnippet = "Replace" },
        telemetry = { enable = false },
        hint = {
          enable = false,
        },
      },
    },
  },
  -- tsserver = {
  --   disable_formatting = true,
  --   settings = {
  --     javascript = {
  --       inlayHints = {
  --         includeInlayEnumMemberValueHints = true,
  --         includeInlayFunctionLikeReturnTypeHints = true,
  --         includeInlayFunctionParameterTypeHints = true,
  --         includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
  --         includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --         includeInlayPropertyDeclarationTypeHints = true,
  --         includeInlayVariableTypeHints = true,
  --       },
  --     },
  --     typescript = {
  --       inlayHints = {
  --         includeInlayEnumMemberValueHints = true,
  --         includeInlayFunctionLikeReturnTypeHints = true,
  --         includeInlayFunctionParameterTypeHints = true,
  --         includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
  --         includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --         includeInlayPropertyDeclarationTypeHints = true,
  --         includeInlayVariableTypeHints = true,
  --       },
  --     },
  --   },
  -- },
  vimls = {},
  -- tailwindcss = {},
  yamlls = {
    schemastore = {
      enable = true,
    },
    settings = {
      yaml = {
        hover = true,
        completion = true,
        validate = true,
        schemas = require("schemastore").json.schemas(),
      },
    },
  },
  -- jdtls = {},
  -- dockerls = {},
  -- graphql = {},
  -- bashls = {},
  -- taplo = {},
  -- omnisharp = {},
  -- kotlin_language_server = {},
  -- emmet_ls = {},
  -- marksman = {},
  -- angularls = {},
  -- sqls = {
  -- settings = {
  --   sqls = {
  --     connections = {
  --       {
  --         driver = "sqlite3",
  --         dataSourceName = os.getenv "HOME" .. "/workspace/db/chinook.db",
  --       },
  --     },
  --   },
  -- },
  -- },
}

function M.on_attach(client, bufnr)
  local caps = client.server_capabilities

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <C-X><C-O>
  -- See `:help omnifunc` and `:help ins-completion` for more information.
  if caps.completionProvider then
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
  end

  -- Use LSP as the handler for formatexpr.
  -- See `:help formatexpr` for more information.
  if caps.documentFormattingProvider then
    buf_set_option("formatexpr", "v:lua.vim.lsp.formatexpr()")
  end

  -- Configure key mappings
  require("config.lsp.keymaps").setup(client, bufnr)

  -- Configure highlighting
  require("config.lsp.highlighter").setup(client, bufnr)

  -- Configure formatting
  require("config.lsp.null-ls.formatters").setup(client, bufnr)

  -- tagfunc
  if caps.definitionProvider then
    buf_set_option("tagfunc", "v:lua.vim.lsp.tagfunc")
  end

  -- sqls
  -- if client.name == "sqls" then
  --   require("sqls").on_attach(client, bufnr)
  -- end

  -- Configure for jdtls
  -- if client.name == "jdt.ls" then
  --   require("jdtls").setup_dap { hotcodereplace = "auto" }
  --   require("jdtls.dap").setup_dap_main_class_configs()
  --   vim.lsp.codelens.refresh()
  -- end

  -- nvim-navic
  if caps.documentSymbolProvider then
    local navic = require "nvim-navic"
    navic.attach(client, bufnr)
  end

  if client.name ~= "null-ls" then
    -- inlay-hints
    local ih = require "inlay-hints"
    ih.on_attach(client, bufnr)

    -- semantic highlighting -- https://github.com/neovim/neovim/pull/21100
    -- if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
    --   local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
    --   vim.api.nvim_create_autocmd("TextChanged", {
    --     group = augroup,
    --     buffer = bufnr,
    --     callback = function()
    --       vim.lsp.buf.semantic_tokens_full()
    --     end,
    --   })
    --   -- fire it first time on load as well
    --   vim.lsp.buf.semantic_tokens_full()
    -- end
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}
-- M.capabilities = capabilities
M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities) -- for nvim-cmp

-- Setup LSP handlers
require("config.lsp.handlers").setup()

local opts = {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

function M.setup()
  vim.lsp.set_log_level "warn"

  -- null-ls
  require("config.lsp.null-ls").setup(opts)

  -- Installer
  require("config.lsp.installer").setup(servers, opts)
end

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
