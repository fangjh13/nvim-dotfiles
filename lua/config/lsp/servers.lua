local servers = {
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#gopls
  gopls = {
    settings = {
      gopls = {
        experimentalPostfixCompletions = true,
        analyses = {
          unusedparams = true,
          shadow = true,
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
    -- lazy-load schemastore when needed
    before_init = function(_, new_config)
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    setup = {
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
          end,
        },
      },
    },
    settings = {
      json = {
        -- Uses the schemastore plugin to fetch predefined JSON schemas
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
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
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = "Disable",
          semicolon = "Disable",
          arrayIndex = "Disable",
        },
        -- diagnostics = {
        --   -- Get the language server to recognize the `vim` global
        --   -- globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins", "MiniTest" },
        --   globals = { "vim", "string" },
        --   -- ignore Lua_LS's diagnostics
        --   -- disable = { "missing-fields", "lowercase-global", "undefined-global", "unused-local", "unused-vararg", "trailing-space" },
        -- },
        codeLens = {
          enable = true,
        },
        doc = {
          privateName = { "^_" },
        },
      },
    },
  },
  -- TOML https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#taplo
  taplo = {},
  yamlls = {
    capabilities = {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    },
    -- lazy-load schemastore when needed
    before_init = function(_, new_config)
      new_config.settings.yaml.schemas =
        vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
    end,
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        keyOrdering = false,
        format = {
          enable = true,
        },
        validate = true,
        schemaStore = {
          -- Must disable built-in schemaStore support to use
          -- schemas from SchemaStore.nvim plugin
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
      },
    },
  },
  dockerls = {},
  bashls = {},
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
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#copilot
  copilot = {
    settings = {
      telemetry = {
        telemetryLevel = "off",
      },
    },
  },
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#clangd
  clangd = {
    capabilities = {
      offsetEncoding = { "utf-8", "utf-16" },
      textDocument = {
        completion = {
          editsNearCursor = true,
        },
      },
    },
    root_markers = {
      ".clangd",
      ".clang-tidy",
      ".clang-format",
      "compile_commands.json",
      "compile_flags.txt",
      "configure.ac", -- AutoTools
      "Makefile",
      "configure.ac",
      "configure.in",
      "config.h.in",
      "meson.build",
      "meson_options.txt",
      "build.ninja",
      ".git",
    },
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  },
}

return servers
