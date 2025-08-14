local M = {}

local nls = require "null-ls"
local nls_utils = require "null-ls.utils"
local b = nls.builtins

local sources = {
  -- formatting
  b.formatting.prettierd, -- markdown
  b.formatting.shfmt,     -- shell script
  b.formatting.stylua.with {
    extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
  },

  -- diagnostics
  -- b.diagnostics.selene,        -- Command line tool designed to help write correct and idiomatic Lua code
  b.diagnostics.buf,           -- Protocol Buffers
  b.diagnostics.yamllint,      -- YAML files
  b.diagnostics.dotenv_linter, -- Lightning-fast linter for .env files
  b.diagnostics.checkmake,     -- make linter
  b.diagnostics.codespell,     -- Codespell finds common misspellings in text files

  -- code actions
  b.code_actions.gitsigns,
  b.code_actions.gitrebase,
  b.code_actions.gomodifytags,

  -- hover
  b.hover.dictionary, -- Shows the first available definition for the current word under the cursor
}

function M.setup(opts)
  nls.setup {
    -- debug = true,
    debounce = 150,
    save_after_format = false,
    sources = sources,
    on_attach = opts.on_attach,
    root_dir = nls_utils.root_pattern(".null-ls-root", "Makefile", ".git"),
  }
end

return M
