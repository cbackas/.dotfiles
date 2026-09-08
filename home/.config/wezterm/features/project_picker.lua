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

-- Auto layouts describe how to build a tab's panes when opening a project
-- with the "layout" modifier held. Each layout is a list of pane specs,
-- applied in order:
--   { name = <string>,                  -- identifies this pane, for `from`/`focus`
--     from = <name>,                    -- pane to split off of; omit for the starting pane
--     direction = 'Bottom'|'Right'|...,  -- split direction, required unless this is the starting pane
--     size = <0-1>,                     -- split size, required unless this is the starting pane
--     command = <string|nil> }          -- shell command to run in this pane, if any
-- `focus` names the pane to activate once the layout is built.

-- claude (35% w) | nvim (65% w)
-- -----------------------------
--        npm run dev (25% h)
local code_layout = {
  focus = 'nvim',
  panes = {
    { name = 'claude', command = 'claude' },
    { name = 'shell', from = 'claude', direction = 'Bottom', size = 0.25, command = 'npm run dev' },
    { name = 'nvim', from = 'claude', direction = 'Right', size = 0.65, command = 'nvim' },
  },
}

-- same as code_layout, but the bottom pane is left as a bare shell - for
-- projects with no dev server to run
local code_layout_no_server = {
  focus = 'nvim',
  panes = {
    { name = 'claude', command = 'claude' },
    { name = 'shell', from = 'claude', direction = 'Bottom', size = 0.25 },
    { name = 'nvim', from = 'claude', direction = 'Right', size = 0.65, command = 'nvim' },
  },
}

-- the layout used when the "auto layout" modifier is held, unless a
-- project-specific override exists in `project_layouts`
local default_layout = code_layout

-- named groups of projects that should all open together (left to right) as
-- separate tabs, e.g. after a reboot to restore a whole workspace at once
local workspaces = {
  {
    name = 'z-cloud',
    projects = {
      'zenith-cloud-ui',
      'sso-login',
      'org-service',
      'device-service',
      'channel-map-service',
      'cms-service',
      'cdk-infra',
    },
  },
}

-- per-project overrides for the auto layout, keyed by project folder name
local project_layouts = {
  ['cdk-infra'] = code_layout_no_server,
}

local workspace_id_prefix = '__workspace__:'

---@param name string
---@return table|nil
local function find_workspace(name)
  for _, ws in ipairs(workspaces) do
    if ws.name == name then
      return ws
    end
  end
  return nil
end

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

-- builds a list of choices for the input selector, one per named workspace
local function get_workspace_choices()
  local choices = {}
  for _, ws in ipairs(workspaces) do
    table.insert(choices, {
      label = PadLabel('workspace:' .. ws.name, table.concat(ws.projects, ' -> ')),
      id = workspace_id_prefix .. ws.name,
    })
  end
  return choices
end

local function active_tab(mux_win)
  for _, item in ipairs(mux_win:tabs_with_info()) do
    -- wezterm.log_info('idx: ', idx, 'tab:', item)
    if item.is_active then
      return item
    end
  end
end

---resolves the layout to actually build for a project: a project-specific
---override if one exists, otherwise `layout` itself. `nil` (bare pane mode)
---passes through unchanged - there's nothing to override.
---@param layout table|nil
---@param id string
---@return table|nil
local function resolve_layout(layout, id)
  if not layout then
    return nil
  end
  local project_name = id:match('([^/]+)/?$')
  return project_layouts[project_name] or layout
end

---builds the panes described by `layout` starting from `root_pane`, sends
---each pane's command after a short delay for the pty to attach, then
---focuses `layout.focus`
---@param root_pane Pane
---@param id string
---@param layout table
local function build_layout(root_pane, id, layout)
  local panes = {}
  for _, spec in ipairs(layout.panes) do
    if spec.from then
      panes[spec.name] = panes[spec.from]:split {
        direction = spec.direction,
        size = spec.size,
        cwd = id,
      }
    else
      panes[spec.name] = root_pane
    end
  end

  -- Defer: freshly-spawned shells need a beat to attach their ptys, else the
  -- send_text lands before anything is listening and is dropped.
  wezterm.time.call_after(0.5, function()
    for _, spec in ipairs(layout.panes) do
      if spec.command then
        panes[spec.name]:send_text(spec.command .. '\n')
      end
    end
  end)

  if layout.focus then
    panes[layout.focus]:activate()
  end
end

---remaps a raw project label to its display/tab title
---@param label string
---@return string
local function title_for_label(label)
  local title = label
  for k, v in pairs(label_remaps) do
    title = title:gsub(k, v)
  end
  return title
end

---switches to the tab for a project if it's already open, otherwise spawns
---a new tab for it - building `layout` if given (with any project-specific
---override applied), or a single bare pane if `layout` is nil
---@param mux_window MuxWindowObj
---@param id string
---@param label string
---@param layout table|nil
---@return MuxTabObj
local function open_or_switch_project_tab(mux_window, id, label, layout)
  local title = title_for_label(label)

  for _, tab in pairs(mux_window:tabs()) do
    if tab:get_title() == title then
      wezterm.log_info('switching to tab: ' .. title)
      tab:activate()
      return tab
    end
  end

  wezterm.log_info('spawning new tab: ' .. title)
  local tab, first_pane, _ = mux_window:spawn_tab({ cwd = id })
  tab:set_title(title)
  local resolved = resolve_layout(layout, id)
  if resolved then
    build_layout(first_pane, id, resolved)
  end
  return tab
end

---replaces the current tab with a new tab for a single project, in the same
---tab position - building `layout` if given (with any project-specific
---override applied), or a single bare pane if `layout` is nil
---@param window Window
---@param pane Pane
---@param id string
---@param label string
---@param layout table|nil
---@return MuxTabObj
local function replace_current_tab(window, pane, id, label, layout)
  local title = title_for_label(label)
  local current_tab_index = active_tab(window:mux_window()).index

  local new_tab, new_pane, _ = window:mux_window():spawn_tab { cwd = id }
  new_tab:set_title(title)
  local resolved = resolve_layout(layout, id)
  if resolved then
    build_layout(new_pane, id, resolved)
  end
  window:perform_action(actions.MoveTab(current_tab_index), new_pane)

  window:perform_action(actions.ActivateTab(current_tab_index + 1), pane)
  window:perform_action(actions.CloseCurrentTab { confirm = false }, pane)

  window:perform_action(actions.ActivateTab(current_tab_index), new_pane)
  return new_tab
end

---opens every project in a named workspace as its own new tab, left to
---right, then focuses the first one
---@param mux_window MuxWindowObj
---@param name string
---@param layout table|nil
local function open_workspace(mux_window, name, layout)
  local ws = find_workspace(name)
  if not ws then
    wezterm.log_error('unknown workspace: ' .. name)
    return
  end

  local projects_root = os.getenv('HOME') .. '/Projects'
  local first_tab
  for _, project_name in ipairs(ws.projects) do
    local tab = open_or_switch_project_tab(mux_window, projects_root .. '/' .. project_name, project_name, layout)
    first_tab = first_tab or tab
  end

  if first_tab then
    first_tab:activate()
  end
end

---replaces the current tab with the first project in a workspace, then
---opens the rest of the workspace's projects as new tabs after it
---@param window Window
---@param pane Pane
---@param name string
---@param layout table|nil
local function open_workspace_replacing_tab(window, pane, name, layout)
  local ws = find_workspace(name)
  if not ws then
    wezterm.log_error('unknown workspace: ' .. name)
    return
  end

  local projects_root = os.getenv('HOME') .. '/Projects'
  replace_current_tab(window, pane, projects_root .. '/' .. ws.projects[1], ws.projects[1], layout)

  local mux_window = window:mux_window()
  for i = 2, #ws.projects do
    local project_name = ws.projects[i]
    open_or_switch_project_tab(mux_window, projects_root .. '/' .. project_name, project_name, layout)
  end
end

---wrapper function for project picking keybinds
---@param callback fun(win: Window, pane: Pane, id: string, label: string)
---@return Action
local function project_picker(callback)
  return wezterm.action_callback(function(window, pane)
    local choices = get_workspace_choices()
    ConcatTables(choices, get_directory_choices(os.getenv('HOME') .. '/Projects'))
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

---@param layout table|nil
local function new_tab_handler(layout)
  return function(window2, _, id, label)
    if not id and not label then
      wezterm.log_error 'cancelled'
      return
    end

    local workspace_name = id:match('^' .. workspace_id_prefix .. '(.+)')
    if workspace_name then
      open_workspace(window2:mux_window(), workspace_name, layout)
      return
    end

    open_or_switch_project_tab(window2:mux_window(), id, label, layout)
  end
end

---@param layout table|nil
local function replace_tab_handler(layout)
  return function(window, pane2, id, label)
    if not id and not label then
      wezterm.log_error 'cancelled'
      return
    end

    local workspace_name = id:match('^' .. workspace_id_prefix .. '(.+)')
    if workspace_name then
      open_workspace_replacing_tab(window, pane2, workspace_name, layout)
      return
    end

    replace_current_tab(window, pane2, id, label, layout)
  end
end

-- Project Picker fuzzy finder: NEW TAB, bare pane
-- opens the picked project (or every project in a picked workspace) as a
-- plain single-pane tab, no auto layout
table.insert(Wez_Conf.keys, {
  key = 'p',
  mods = 'SUPER',
  action = project_picker(new_tab_handler(nil)),
})

-- Project Picker fuzzy finder: REPLACE TAB, bare pane
-- replaces the current tab with the picked project as a plain single-pane
-- tab; for a workspace, replaces the current tab with its first project and
-- adds the rest as new plain tabs
table.insert(Wez_Conf.keys, {
  key = 'P',
  mods = 'SUPER|SHIFT',
  action = project_picker(replace_tab_handler(nil)),
})

-- Project Picker fuzzy finder: NEW TAB, auto layout
-- same as SUPER+p but builds `default_layout` (or a project-specific
-- override from `project_layouts`)
table.insert(Wez_Conf.keys, {
  key = 'p',
  mods = 'SUPER|ALT',
  action = project_picker(new_tab_handler(default_layout)),
})

-- Project Picker fuzzy finder: REPLACE TAB, auto layout
-- same as SUPER+SHIFT+p but builds `default_layout` (or a project-specific
-- override from `project_layouts`)
table.insert(Wez_Conf.keys, {
  key = 'P',
  mods = 'SUPER|SHIFT|ALT',
  action = project_picker(replace_tab_handler(default_layout)),
})
