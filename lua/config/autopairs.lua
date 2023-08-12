local M = {}

function M.setup()
  local npairs = require "nvim-autopairs"
  npairs.setup {
    check_ts = true,
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
  -- npairs.add_rules(require "nvim-autopairs.rules.endwise-lua")
end

return M
