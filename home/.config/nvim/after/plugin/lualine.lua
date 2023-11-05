local lualine = require('lualine')

vim.cmd [[highlight SLCopilot guifg=#6CC644 guibg=None]]

local function lsp_status()
  local current_buffer = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({
    bufnr = current_buffer
  })

  local client_names = {}
  local copilot = false
  for _, client in pairs(clients) do
    if client.name == 'copilot' then
      copilot = true
    else
      client_names[client.name] = true
    end
  end

  local nvim_lsp_linters = require('lint')._resolve_linter_by_ft(vim.bo.filetype)
  if nvim_lsp_linters then
    for _, linter in pairs(nvim_lsp_linters) do
      client_names[linter] = true
    end
  end

  local client_list = vim.tbl_keys(client_names)

  local message = "LSP Inactive"

  if #client_list > 0 then
    message = "[" .. table.concat(client_list, ", ") .. "]"
  end

  if copilot then
    message = message .. "%#SLCopilot#" .. " %*"
  end

  return message
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
    lualine_c = {
      {
        'filename',
        file_status = false,
        path = 1,
        shorting_target = 100,
      },
    },
    lualine_x = { {
      'diagnostics',
      sources = {
        'nvim_diagnostic',
      },
    }, py_env, 'filetype', lsp_status },
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
