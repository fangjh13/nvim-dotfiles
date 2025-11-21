local servers = {
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#gopls
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
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#jsonls
  jsonls = {
    settings = {
      json = {
        -- Uses the schemastore plugin to fetch predefined JSON schemas
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
    setup = {
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
          end,
        },
      },
    },
  },
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#pyright
  pyright = {
    settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          -- https://microsoft.github.io/pyright/#/configuration?id=diagnostic-settings-defaults
          typeCheckingMode = "off", -- "off", "basic", "standard",  "strict"
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "openFilesOnly",
          -- stubPath = vim.fn.stdpath "data" .. "/lazy/python-type-stubs/stubs",
        },
      },
    },
  },
  -- Python linter and code formatter
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ruff
  ruff = {
    cmd_env = { RUFF_TRACE = "messages" },
    init_options = {
      settings = {
        logLevel = "debug",
        lint = {
          ignore = {
            "E402", -- [E402] Module level import not at top of file
          },
        },
      },
    },
  },
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
        hint = {
          enable = true,
          paramName = "Literal",
          setType = true,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          -- globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins", "MiniTest" },
          globals = { "vim", "string" },
          -- ignore Lua_LS's diagnostics
          -- disable = { "missing-fields", "lowercase-global", "undefined-global", "unused-local", "unused-vararg", "trailing-space" },
        },
        workspace = {
          checkThirdParty = false,
          -- Make the server aware of Neovim runtime files
          library = {
            vim.env.VIMRUNTIME,
            --[[ "${3rd}/busted/library", ]]
            "${3rd}/luv/library",
          },
        },
      },
    },
  },
  vimls = {},
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
  dockerls = {},
  bashls = {},
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
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#nixd
  nixd = {
    settings = {
      nixd = {
        nixpkgs = {
          expr = 'import (builtins.getFlake ("git+file://" + toString ./.)).inputs.nixpkgs { }',
        },
        formatting = {
          command = { "alejandra" },
        },
        options = {
          nixos = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.deskmini.options',
          },
          home_manager = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."fython@deskmini".options',
          },
          flake_parts = {
            expr = 'let flake = builtins.getFlake ("git+file://" + toString ./.); in flake.debug.options // flake.currentSystem.options',
          },
        },
      },
    },
  },
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#rust_analyzer
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        diagnostics = {
          enable = true,
        },
        files = {
          excludeDirs = {
            ".direnv",
            ".git",
            "target",
          },
        },
        check = {
          command = "clippy",
          extraArgs = {
            "--no-deps",
          },
        },
        -- Make the rust-analyzer use its own profile,
        -- so you can run cargo build without that being blocked while rust-analyzer runs
        cargo = {
          extraEnv = { CARGO_PROFILE_RUST_ANALYZER_INHERITS = "dev" },
          extraArgs = { "--profile", "rust-analyzer" },
        },
      },
    },
  },
}

return servers
