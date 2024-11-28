local M = {}

function M.setup()
  local npairs = require "nvim-autopairs"
  npairs.setup {
    check_ts = true, -- use treesitter to check for a pair
    ts_config = {
      lua = { "string", "source" }, -- it will not add a pair on that treesitter node
      javascript = { "string", "template_string" },
      java = false, -- don't check treesitter on java
    },
    fast_wrap = {
      map = "<C-d>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = [=[[%'%"%>%]%)%}%,]]=],
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      manual_position = true,
      highlight = "Search",
      highlight_grey = "Comment",
    },
  }
end

return M
