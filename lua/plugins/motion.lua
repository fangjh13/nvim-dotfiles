return {

  -- [[ Jumps ]]
  {
    "ggandor/leap.nvim",
    keys = { "s", "S" },
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
      vim.keymap.set("n", "S", "<Plug>(leap-from-window)")

      -- Remote action
      -- Perform an action in a remote location, Once returning to Normal mode, it jumps back (Example: `zs{leap}yap`, `vzs{leap}apy`, or `yzs{leap}ap`)
      vim.keymap.set({ "n", "x", "o" }, "zs", function()
        require("leap.remote").action()
      end)
      -- Forced linewise version (Example: `zS{leap}y`):
      vim.keymap.set({ "n", "o" }, "zS", function()
        require("leap.remote").action { input = "V" }
      end)

      -- Highly recommended: define a preview filter to reduce visual noise
      -- and the blinking effect after the first keypress
      -- (`:h leap.opts.preview`). You can still target any visible
      -- positions if needed, but you can define what is considered an
      -- exceptional case.
      -- Exclude whitespace and the middle of alphabetic words from preview:
      --   foobar[baaz] = quux
      --   ^----^^^--^^-^-^--^
      require("leap").opts.preview = function(ch0, ch1, ch2)
        return not (ch1:match "%s" or (ch0:match "%a" and ch1:match "%a" and ch2:match "%a"))
      end

      -- Define equivalence classes for brackets and quotes, in addition to
      -- the default whitespace group:
      require("leap").opts.equivalence_classes = {
        " \t\r\n",
        "([{",
        ")]}",
        "'\"`",
      }
    end,
  },

  -- [[ Better % ]
  {
    "andymass/vim-matchup",
    event = "CursorMoved",
  },
}
