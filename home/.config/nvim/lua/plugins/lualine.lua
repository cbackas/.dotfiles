local config = function()
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

  -- define visual settings for harpoon tabline
  local yellow = '#DCDCAA'
  local yellow_orange = '#D7BA7D'
  local background_color = "#282829"
  local grey = "#797C91"
  local light_blue = "#9CDCFE"
  vim.api.nvim_set_hl(0, "HarpoonInactive", { fg = grey, bg = background_color })
  vim.api.nvim_set_hl(0, "HarpoonActive", { fg = light_blue, bg = background_color })
  vim.api.nvim_set_hl(0, "HarpoonNumberActive", { fg = yellow, bg = background_color })
  vim.api.nvim_set_hl(0, "HarpoonNumberInactive", { fg = yellow_orange, bg = background_color })
  vim.api.nvim_set_hl(0, "TabLineFill", { fg = "white", bg = background_color })

  local harpoon = require('harpoon')

  function Harpoon_files()
    local contents = {}
    local marks_length = harpoon:list():length()
    local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
    for index = 1, marks_length do
      local harpoon_file_path = harpoon:list():get(index).value
      local file_name = harpoon_file_path == "" and "(empty)" or vim.fn.fnamemodify(harpoon_file_path, ':t')

      if current_file_path == harpoon_file_path then
        contents[index] = string.format("%%#HarpoonNumberActive# %s. %%#HarpoonActive#%s ", index, file_name)
      else
        contents[index] = string.format("%%#HarpoonNumberInactive# %s. %%#HarpoonInactive#%s ", index, file_name)
      end
    end

    return table.concat(contents)
  end

  require('lualine').setup {
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
    extensions = {
      'oil',
      'fugitive',
      'trouble'
    },
  }
end

return {
  'nvim-lualine/lualine.nvim',
  config = config
}
