local M = {}

local servers = {
  gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
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
        staticcheck = true,
      },
    },
  },
  html = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          typeCheckingMode = "off",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
          -- diagnosticMode = "openFilesOnly",
          -- stubPath = vim.fn.stdpath "data" .. "/lazy/python-type-stubs/stubs",
        },
      },
    },
  },
  ruff = {
    cmd_env = { RUFF_TRACE = "messages" },
    init_options = {
      settings = {
        logLevel = "debug",
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

  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = vim.split(package.path, ";"),
        },
        -- diagnostics = {
        --   -- Get the language server to recognize the `vim` global
        --   globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins", "MiniTest" },
        --   -- ignore Lua_LS's diagnostics
        --   -- disable = { "missing-fields", "lowercase-global", "undefined-global", "unused-local", "unused-vararg", "trailing-space" },
        -- },
        format = {
          -- disable lua_ls format use null-ls stylua instead
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
        schemaStore = {
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },
  sqlls = {},
  -- jdtls = {},
  dockerls = {},
  -- graphql = {},
  bashls = {},
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

  local function buf_set_option(option, value)
    vim.api.nvim_set_option_value(option, value, { buf = bufnr })
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

  -- pyright
  if client.name == "pyright" then
    -- local utils = require "utils"
    -- utils.map_buf(
    --   "n",
    --   "<leader>lo",
    --   "<cmd>PyrightOrganizeImports<cr>",
    --   { silent = true, desc = "Organize Imports", noremap = true },
    --   bufnr
    -- )
    -- utils.map("n", "<leader>lC", function()
    --   require("dap-python").test_class()
    -- end, { silent = true, desc = "Debug Class", noremap = true, buffer = bufnr })
    -- utils.map("n", "<leader>lM", function()
    --   require("dap-python").test_method()
    -- end, { silent = true, desc = "Debug Method", noremap = true, buffer = bufnr })
    -- utils.map("v", "<leader>lE", function()
    --   require("dap-python").debug_selection()
    -- end, { silent = true, desc = "Debug Selection", noremap = true, buffer = bufnr })
  end

  -- ruff_lsp
  if client.name == "ruff" then
    client.server_capabilities.hoverProvider = false
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
-- for nvim-cmp
M.capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- Setup LSP handlers
require("config.lsp.handlers").setup()

local opts = {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  init_options = {
    usePlaceholders = true,
  },
}

function M.setup()
  vim.lsp.set_log_level "error"

  -- null-ls
  require("config.lsp.null-ls").setup(opts)

  -- Install dependencies and set up servers via lspconfig
  require("config.lsp.installer").setup(servers, opts)
end

local diagnostics_active = true

function M.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
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
