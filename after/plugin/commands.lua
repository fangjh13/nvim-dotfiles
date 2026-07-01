-- CopyFilePath copies the current file path with the current line or selected line range.
-- Usage: :CopyFilePath [abs|absolute], or select lines and run :'<,'>CopyFilePath [abs|absolute].
vim.api.nvim_create_user_command("CopyFilePath", function(opts)
  -- Determine whether to use an absolute or relative path
  local file_path
  if opts.args and (opts.args == "abs" or opts.args == "absolute") then
    -- Use the absolute path if the argument is "abs" or "absolute"
    file_path = vim.fn.expand "%:p"
  else
    -- Default to the relative path
    file_path = vim.fn.expand "%:."
  end

  local line_start = opts.range > 0 and opts.line1 or vim.fn.line "."
  local line_end = opts.range > 0 and opts.line2 or line_start
  local line_range = tostring(line_start)
  if line_start ~= line_end then
    line_range = line_range .. "-" .. line_end
  end
  local result_string = file_path .. ":" .. line_range

  vim.fn.setreg("+", result_string)

  vim.notify("Copied to clipboard: " .. result_string, vim.log.levels.INFO)
end, {
  nargs = "?", -- Allow zero or one argument
  range = true,
  desc = "Copy file path and line/range. Pass 'abs' for absolute path.",
  complete = function(arglead, cmdline, cursorpos)
    -- Provide simple autocompletion for the "abs" argument
    return { "abs", "absolute" }
  end,
})

-- reopen the most recently closed buffer
vim.cmd [[
    augroup bufclosetrack
      au!
      autocmd WinLeave * let g:lastWinName = @%
    augroup END
    function! LastWindow()
      exe "vsplit " . g:lastWinName
    endfunction
    command -nargs=0 LastWindow call LastWindow()
]]
