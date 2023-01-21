local M = {}

function M.setup()
    local nvim_lsp = require "lspconfig"

    vim.lsp.set_log_level "warn"

    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local on_attach = function(client, bufnr)
        local function buf_set_option(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        -- Enable completion triggered by <c-x><c-o>
        -- See `:help omnifunc` and `:help ins-completion` for more information.
        buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Use LSP as the handler for formatexpr.
        -- See `:help formatexpr` for more information.
        vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

        -- Configure key mappings
        require("config.lsp.keymaps").setup(client, bufnr)

        -- Configure highlighting
        require("config.lsp.highlighter").setup(client)

        -- Configure formatting
        require("config.lsp.null-ls.formatters").setup(client, bufnr)
    end

    -- null-ls
    local opts = {
        on_attach = on_attach,
    }
    require("config.lsp.null-ls").setup(opts)

    -- [[ go ]]
    nvim_lsp.gopls.setup {
        cmd = { "gopls", "serve" },
        filetypes = { "go", "gomod" },
        root_dir = nvim_lsp.util.root_pattern("go.work", "go.mod", ".git"),
        -- for postfix snippets and analyzers
        capabilities = capabilities,
        settings = {
            gopls = {
                experimentalPostfixCompletions = true,
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
                staticcheck = true,
            },
        },
        on_attach = on_attach,
    }

    function go_org_imports(wait_ms)
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

    -- [[ Lua ]]
    local sumneko_root_path = ""
    local sumneko_binary = ""

    if vim.fn.has "mac" == 1 then
        local p = "/opt/homebrew/Cellar/lua-language-server/3.5.6"
        sumneko_binary = p .. "/bin/lua-language-server"
        sumneko_root_path = p .. "/libexec"
    elseif vim.fn.has "unix" == 1 then
        sumneko_root_path = "/usr/local/lua-language-server"
        sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"
    else
        print "Unsupported system for sumneko"
    end

    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    local lib = vim.api.nvim_get_runtime_file("", true)
    table.insert(lib, vim.fn.expand "$VIMRUNTIME/lua")
    table.insert(lib, vim.fn.expand "$VIMRUNTIME/lua/vim/lsp")

    -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
    require("neodev").setup {
        -- add any options here, or leave empty to use the default settings
    }

    nvim_lsp.sumneko_lua.setup {
        cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            Lua = {
                format = {
                    enable = true,
                    -- Put format options here
                    -- NOTE: the value should be STRING!!
                    defaultConfig = {
                        indent_style = "space",
                        indent_size = "2",
                    },
                },
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = lib,
                    checkThirdParty = false,
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
                -- enable call snippets, neodev installed
                completion = {
                    callSnippet = "Replace",
                },
            },
        },
    }

    -- [[ Python ]]
    nvim_lsp.pylsp.setup {
        on_attach = on_attach,
        settings = {
            pylsp = {
                plugins = {
                    pylint = { enabled = true, executable = "pylint" },
                    pyflakes = { enabled = false },
                    pycodestyle = { enabled = false },
                    jedi_completion = { fuzzy = true },
                    pyls_isort = { enabled = true },
                    pylsp_mypy = { enabled = true },
                },
            },
        },
        flags = {
            debounce_text_changes = 200,
        },
        capabilities = capabilities,
    }
end

return M
