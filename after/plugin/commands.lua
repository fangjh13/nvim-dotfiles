-- command `CopyFilePath` to copy current file path to clipboard
vim.api.nvim_create_user_command("CopyFilePath", function()
  -- "let @+ = expand('%:p')"

  -- Get the full path of the current file
  local file_path = vim.fn.expand "%:p"
  -- Set the clipboard to the file path
  vim.fn.setreg("+", file_path)

  vim.notify("Copied file path to clipboard: " .. file_path, vim.log.levels.INFO)
end, { nargs = 0, desc = "Copy current file path to clipboard" })

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
