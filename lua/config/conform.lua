return {
  "stevearc/conform.nvim",
  opts = {
    default_format_opts = {
      timeout_ms = 3000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
      lsp_format = "fallback", -- not recommended to change
    },
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      python = { "ruff_organize_imports", "ruff_format", "ruff_fix" },
      go = { "goimports", "gofmt" },
      sql = { "sqlfluff" },
    },
    -- The options you set here will be merged with the builtin formatters.
    -- You can also define any custom formatters here.
    formatters = {
      -- # Example of using dprint only when a dprint.json file is present
      -- dprint = {
      --   condition = function(ctx)
      --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
      --   end,
      -- },
      --
      -- # Example of using shfmt with extra args
      -- shfmt = {
      --   prepend_args = { "-i", "2", "-ci" },
      -- },
      sqlfluff = {
        require_cwd = true,
        cwd = function(self, ctx)
          return require("conform.util").root_file { ".sqlfluff", "pyproject.toml", ".git" }(self, ctx)
        end,
        args = { "format", "--dialect=ansi", "-" },
      },
    },
  },
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = {
        ensure_installed = {
          "stylua",
          "shfmt",
          "goimports",
          "sqlfluff",
        },
      },
    },
  },
}
