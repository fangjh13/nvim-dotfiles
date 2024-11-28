local M = {}
local cmd = vim.cmd

function M.create_augroup(autocmds, name)
  cmd("augroup " .. name)
  cmd "autocmd!"
  for _, autocmd in ipairs(autocmds) do
    cmd("autocmd " .. table.concat(autocmd, " "))
  end
  cmd "augroup END"
end

function M.add_rtp(path)
  local rtp = vim.o.rtp
  rtp = rtp .. "," .. path
end

-- helper to create mappings with the noremap option set to true by default
function M.map(mode, keys, action, options)
  local opts = { noremap = true }
  if options then
    opts = vim.tbl_extend("force", opts, options)
  end
  -- vim.api.nvim_set_keymap(mode, keys, action, opts)
  vim.keymap.set(mode, keys, action, opts)
end

function M.map_lua(mode, keys, action, options)
  if options == nil then
    options = {}
  end
  vim.api.nvim_set_keymap(mode, keys, "<cmd>lua " .. action .. "<cr>", options)
end

function M.map_buf(mode, keys, action, options, buf_nr)
  if options == nil then
    options = {}
  end
  local buf = buf_nr or 0
  vim.api.nvim_buf_set_keymap(buf, mode, keys, action, options)
end

function M.map_lua_buf(mode, keys, action, options, buf_nr)
  if options == nil then
    options = {}
  end
  local buf = buf_nr or 0
  vim.api.nvim_buf_set_keymap(buf, mode, keys, "<cmd>lua " .. action .. "<cr>", options)
end

-- helper functions print table
function M.tprint(tb, indent)
  if not indent then
    indent = 0
  end
  if type(tb) == "table" then
    local s = "{ "
    for k, v in pairs(tb) do
      s = s .. "\n" .. string.rep("  ", indent + 1)
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. _G.utils.tprint(v, indent + 1) .. ","
    end
    return s .. "\n" .. string.rep("  ", indent) .. "}"
  else
    return tostring(tb)
  end
end

function M.log(msg, hl, name)
  name = name or "Neovim"
  hl = hl or "Todo"
  vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

function M.warn(msg, name)
  vim.notify(msg, vim.log.levels.WARN, { title = name })
end

function M.error(msg, name)
  vim.notify(msg, vim.log.levels.ERROR, { title = name })
end

function M.info(msg, name)
  vim.notify(msg, vim.log.levels.INFO, { title = name })
end

function M.is_file_exists(path)
  -- local stat = vim.loop.fs_stat(path)
  -- return stat and stat.type == "file"
  return vim.fn.filereadable(path) == 1
end

-- Global Access
_G.utils = M

_G.prequire = function(...)
  local status, lib = pcall(require, ...)
  if status then
    return lib
  end
  return nil
end
return M
