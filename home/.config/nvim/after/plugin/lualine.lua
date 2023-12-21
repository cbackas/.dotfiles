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

local harpoon = require('harpoon')

function Harpoon_files()
  local contents = {}

  local marks_length = harpoon:list():length()

  for idx = 1, marks_length do
    -- local file_path = hp_marks.get_marked_file_name(idx)
    local file_path = harpoon:list():get(idx).value
    local file_name
    if file_path == "" then
      file_name = "(empty)"
    else
      file_name = vim.fn.fnamemodify(file_path, ':t')
    end
    local current_file_path = vim.fn.expand("%:f")

    local prev = ""
    if idx ~= 1 then
      prev = " "
    end
    local next = ""
    if idx < marks_length then
      next = " "
    end
    if file_path == current_file_path then
      contents[idx] = string.format("%%#HarpoonNumberActive#%s%s. %%#HarpoonActive#%s%s", prev, idx, file_name,
        next)
    else
      contents[idx] = string.format("%%#HarpoonNumberInactive#%s%s. %%#HarpoonInactive#%s%s", prev, idx, file_name, next)
    end
  end

  return table.concat(contents)
end

lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { '|', '|' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      {
        function()
          local mode = vim.api.nvim_get_mode().mode

          local mode_map = {
            n = "",
            i = "󰈸",
            c = "",
            v = "",
            V = "",
            [""] = "󰳂",
            R = "󰑖",
            s = "󰸱",
            S = "󰸱",
            [""] = "󰸱",
            t = "",
          }

          local icon = mode_map[mode] or mode
          return " " .. icon .. " "
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
    lualine_x = { 'filetype' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {
    lualine_a = { { Harpoon_files } },
  },
  extensions = {},
}
