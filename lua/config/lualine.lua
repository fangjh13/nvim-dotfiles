local M = {}

-- Color table for highlights
local colors = {
    bg = "#202328",
    fg = "#bbc2cf",
    yellow = "#ECBE7B",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#98be65",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    blue = "#51afef",
    red = "#ec5f67",
}

local function separator()
    return "%="
end

local function lsp_client()
    local buf_clients = vim.lsp.get_active_clients()
    if next(buf_clients) == nil then
        return ""
    end
    local buf_client_names = {}
    for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" then
            table.insert(buf_client_names, client.name)
        end
    end
    return "[" .. table.concat(buf_client_names, ", ") .. "]"
end

local function lsp_progress(_, is_active)
    if not is_active then
        return
    end
    local messages = vim.lsp.util.get_progress_messages()
    if #messages == 0 then
        return ""
    end
    local status = {}
    for _, msg in pairs(messages) do
        local title = ""
        if msg.title then
            title = msg.title
        end
        table.insert(status, (msg.percentage or 0) .. "%% " .. title)
    end
    local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners
    return table.concat(status, "  ") .. " " .. spinners[frame + 1]
end

function M.setup()
    require('lualine').setup {
        sections = {
            lualine_z = {
                { lsp_progress },
                { lsp_client, icon = " ", color = { gui = "bold" } },
                { "location", icon = " " },
            }
        },
        options = {
            theme = 'dracula-nvim'
        },
    }
end

return M

--[[ {
  extensions = {},
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {},
  options = {
    always_divide_middle = true,
    component_separators = {
      left = "",
      right = ""
    },
    disabled_filetypes = {
      statusline = {},
      winbar = {}
    },
    globalstatus = false,
    icons_enabled = true,
    ignore_focus = {},
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000
    },
    section_separators = {
      left = "",
      right = ""
    },
    theme = "dracula-nvim"
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" }
  },
  tabline = {},
  winbar = {}
} ]]
