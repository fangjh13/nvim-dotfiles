local M = {}

local nls = require "null-ls"
local nls_utils = require "null-ls.utils"
local b = nls.builtins

local with_diagnostics_code = function(builtin)
  return builtin.with {
    diagnostics_format = "#{m} [#{c}]",
  }
end

local sources = {
  -- formatting
  b.formatting.prettierd, -- markdown
  b.formatting.shfmt, -- shell script
  b.formatting.fixjson,
  b.formatting.black.with {
    extra_args = { "--fast", "--line-length", "79", "--preview" },
  },
  b.formatting.isort,
  -- lua
  b.formatting.stylua.with {
    extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
  },
  -- with_root_file(b.formatting.stylua, "stylua.toml"),

  -- diagnostics
  b.diagnostics.write_good,
  -- b.diagnostics.markdownlint,
  b.diagnostics.eslint_d,
  b.diagnostics.flake8.with { extra_args = { "--ignore=E203" } },
  b.diagnostics.tsc,
  b.diagnostics.selene, -- lua
  -- with_root_file(b.diagnostics.selene, "selene.toml"),
  with_diagnostics_code(b.diagnostics.shellcheck),

  -- code actions
  b.code_actions.gitsigns,
  b.code_actions.eslint_d,
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
