local M = {}

local nls = require "null-ls"
local nls_utils = require "null-ls.utils"
local b = nls.builtins

local sources = {
  -- formatting
  b.formatting.prettierd, -- markdown
  b.formatting.shfmt, -- shell script
  b.formatting.black.with {
    extra_args = { "--fast", "--line-length", "79", "--preview" },
  },
  b.formatting.isort, -- python sort imports
  -- lua
  b.formatting.stylua.with {
    extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
  },

  -- diagnostics
  b.diagnostics.write_good,
  b.diagnostics.selene, -- lua
  b.diagnostics.buf, -- Protocol Buffers
  b.diagnostics.yamllint, -- YAML files

  -- code actions
  b.code_actions.gitsigns,
  b.code_actions.gitrebase,
  b.code_actions.gomodifytags,

  -- hover
  b.hover.dictionary,
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
