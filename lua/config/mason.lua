local icons = require "config.icons"

return {
  "mason-org/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  opts_extend = { "ensure_installed" },
  opts = {
    border = "rounded",
    icons = {
      package_installed = icons.lsp.server_installed,
      package_pending = icons.lsp.server_pending,
      package_uninstalled = icons.lsp.server_uninstalled,
    },
    ensure_installed = {
      "stylua",
    },
  },
  ---@param opts MasonSettings | {ensure_installed: string[]}
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require "mason-registry"
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        -- trigger FileType event to possibly load this newly installed LSP server
        require("lazy.core.handler.event").trigger {
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        }
      end, 100)
    end)

    mr.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)
  end,
}
