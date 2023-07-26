local devicons = require('nvim-web-devicons')
local lualine = require('lualine')

local function lsp_status()
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then return '' end
  local client_names = ""
  for _, client in pairs(clients) do
    if client_names ~= "" then
      client_names = client_names .. ", "
    end
    client_names = client_names .. client.name
  end
  return "[" .. client_names .. "]"
end

local function env_cleanup(venv)
  if string.find(venv, "/") then
    local final_venv = venv
    for w in venv:gmatch "([^/]+)" do
      final_venv = w
    end
    venv = final_venv
  end
  return venv
end

local py_env = {
  function()
    if vim.bo.filetype == "python" then
      local venv = os.getenv "CONDA_DEFAULT_ENV" or os.getenv "VIRTUAL_ENV"
      if venv then
        local icons = require "nvim-web-devicons"
        local py_icon, _ = icons.get_icon ".py"
        return string.format(" " .. py_icon .. " (%s)", env_cleanup(venv))
      end
    end
    return ""
  end,
  color = { fg = "#98be65" },
}

lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { '|', '|' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      {
        function()
          return " " .. "" .. " "
        end,
        padding = { left = 0, right = 0 },
        color = {},
        cond = nil,
      },
    },
    lualine_b = { 'branch', 'diff' },
    lualine_c = { 'filename' },
    lualine_x = { 'searchcount', py_env, 'filetype', lsp_status },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}
