local wezterm = require 'wezterm' --[[@as Wezterm]]
local actions = wezterm.action

--
-- Mux tab creation
--

local label_remaps = {
  ['%s%s%s.*'] = '',
  ['acvs%-ses%-'] = "",
  ['acvs%-osp%-'] = "",
  ['partner%-portal%-'] = "pp-",
}

-- given a path, builds a list of choices for the input selector
local function get_directory_choices(path, label_prefix)
  local prefix = (label_prefix and label_prefix .. ':') or ''
  local cmd = 'ls -d ' .. path .. '/*/ 2>/dev/null'
  local dirs = {}
  local pfile = io.popen(cmd)
  if not pfile then
    return dirs
  end

  for dir in pfile:lines() do
    local dir_name = dir:match('([^/]+)/?$') -- Extract the last part of the path
    table.insert(dirs, CreateDirectoryEntry(prefix .. dir_name, path .. '/' .. dir_name))
  end

  pfile:close()
  return dirs
end

local function active_tab(mux_win)
  for _, item in ipairs(mux_win:tabs_with_info()) do
    -- wezterm.log_info('idx: ', idx, 'tab:', item)
    if item.is_active then
      return item
    end
  end
end

---wrapper function for project picking keybinds
---@param callback fun(win: Window, pane: Pane, id: string, label: string)
---@return Action
local function project_picker(callback)
  return wezterm.action_callback(function(window, pane)
    local choices = get_directory_choices(os.getenv('HOME') .. '/Projects')
    ConcatTables(choices, get_directory_choices(os.getenv('HOME') .. '/.dotfiles/home/.config', 'conf'))
    ConcatTables(choices, { CreateDirectoryEntry('.dotfiles', os.getenv('HOME') .. '/.dotfiles') })

    window:perform_action(
      actions.InputSelector {
        action = wezterm.action_callback(callback),
        title = 'Which project would you like to open?',
        choices = choices,
        fuzzy = true,
      },
      pane
    )
  end)
end

-- Project Picker fuzzy finder: NEW TAB
-- when you select an option it will switch to that project's tab if it exists or spawn a new one
table.insert(Wez_Conf.keys, {
  key = 'p',
  mods = 'SUPER',
  action = project_picker(function(window2, _, id, label)
    if not id and not label then
      wezterm.log_error 'cancelled'
      return
    end

    local title = label
    for k, v in pairs(label_remaps) do
      title = title:gsub(k, v)
    end

    local mux_window = window2:mux_window()
    for _, tab in pairs(mux_window:tabs()) do
      local tab_title = tab:get_title()
      if tab_title == title then
        wezterm.log_info('switching to tab: ' .. title)
        tab:activate()
        return
      end
    end

    wezterm.log_info('spawning new tab: ' .. title)
    local tab, _, _ = mux_window:spawn_tab({ cwd = id })
    tab:set_title(title)
  end),
})

-- Project Picker fuzzy finder: REPLACE TAB
-- when you select an option it will replace the current tab with a tab for that project
table.insert(Wez_Conf.keys, {
  key = 'P',
  mods = 'SUPER|SHIFT',
  action = project_picker(function(window, pane2, id, label)
    if not id and not label then
      wezterm.log_error 'cancelled'
      return
    end

    local title = label
    for k, v in pairs(label_remaps) do
      title = title:gsub(k, v)
    end

    local current_tab_index = active_tab(window:mux_window()).index

    -- create new tab
    local new_tab, new_pane, _ = window:mux_window():spawn_tab { cwd = id }
    new_tab:set_title(title)
    window:perform_action(actions.MoveTab(current_tab_index), new_pane)

    -- close old tab
    window:perform_action(actions.ActivateTab(current_tab_index + 1), pane2)
    window:perform_action(actions.CloseCurrentTab { confirm = false }, pane2)

    -- ensure we're on the new tab again
    window:perform_action(actions.ActivateTab(current_tab_index), new_pane)
  end),
})
