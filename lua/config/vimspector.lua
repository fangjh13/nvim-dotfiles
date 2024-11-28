local M = {}

local vimspector_python = [[
{
  "configurations": {
    "<name>: Launch": {
      "adapter": "debugpy",
      "configuration": {
        "name": "Python: Launch",
        "type": "python",
        "request": "launch",
        "python": "%s",
        "stopOnEntry": true,
        "console": "externalTerminal",
        "debugOptions": [],
        // change path to main python file or use `${file}` variable is the current opened file
        "program": "${file}"
      }
    }
  }
}
]]

local vimspector_go = [[
{
  "configurations": {
    "<name>: Launch": {
      "adapter": "delve",
      "filetypes": ["go"],
      "variables": {
        // example, to disable delve's go version check
        "dlvFlags": "--check-go-version=false"
      },
      "configuration": {
        "request": "launch",
        // This can be the absolute path of the project
        "program": "${fileDirname}",
        "mode": "debug",
        "env": {},
        // "args": ["-args1", "value1", "-args2", "value2"],
        "buildFlags": ""
      }
    }
  }
}
]]

--- Generate debug profile. Currently for Python only
function M.generate_debug_profile()
  -- Get current file type
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
  local debugProfile = ""

  if ft == "python" then
    -- Get Python path
    local python3 = vim.fn.exepath "python"
    debugProfile = string.format(vimspector_python, python3)
  elseif ft == "go" then
    debugProfile = vimspector_go
  else
    utils.info("Unsupported language - " .. ft, "Generate Debug Profile")
  end

  local file_name = ".vimspector.json"
  if utils.is_file_exists(file_name) then
    -- open file in a new window
    vim.api.nvim_command("vsplit " .. vim.fn.fnameescape(file_name))
  else
    -- Generate debug profile in a new window
    vim.cmd [[vsp]]
    local win = vim.api.nvim_get_current_win()
    local bufNew = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(bufNew, file_name)
    vim.api.nvim_win_set_buf(win, bufNew)

    local lines = {}
    for s in debugProfile:gmatch "[^\r\n]+" do
      table.insert(lines, s)
    end
    vim.api.nvim_buf_set_lines(bufNew, 0, -1, false, lines)
  end
end

function M.setup()
  vim.cmd [[
      " add new command
      command! VimspectorLaunch call vimspector#Launch()
      " for normal mode - the word under the cursor
      nmap <Leader>di <Plug>VimspectorBalloonEval
      " for visual mode, the visually selected text
      xmap <Leader>di <Plug>VimspectorBalloonEval
  ]]
end

return M
