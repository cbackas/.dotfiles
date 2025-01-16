local wezterm = require 'wezterm' --[[@as Wezterm]]
local actions = wezterm.action

---@param pane Pane
---@return boolean
local function is_vim(pane)
  local process_info = pane:get_foreground_process_info()
  local process_name = process_info and process_info.name

  return process_name == 'nvim' or process_name == 'vim' or process_name == 'nvim.exe' or process_name == 'vim.exe'
end

---@param tab MuxTabObj
---@return Pane | nil
local function find_vim_pane(tab)
  for _, pane in ipairs(tab:panes_with_info()) do
    if is_vim(pane.pane) then
      return pane
    end
  end
  return nil
end

-- keys
Wez_Conf.leader = { key = ' ', mods = 'CTRL', timeout_milliseconds = 1000 }
Wez_Conf.keys = {
  { key = 'L', mods = 'CTRL', action = actions.ShowDebugOverlay },
  -- close current pane
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- close current tab
  {
    key = 'w',
    mods = 'CMD|SHIFT',
    action = actions.CloseCurrentTab { confirm = true },
  },
  -- vertical split
  {
    key = '\\',
    mods = 'LEADER',
    action = actions.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- horizontal split (50%)
  {
    key = '-',
    mods = 'LEADER',
    action = actions.SplitPane {
      direction = 'Down',
      size = { Percent = 50 },
    },
  },
  -- horizontal split (30%) (for lil terminals under my main window)
  {
    key = '_',
    mods = 'LEADER|SHIFT',
    action = actions.SplitPane {
      direction = 'Down',
      size = { Percent = 30 },
    },
  },
  -- rename active tab
  {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = actions.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  -- rotate panes
  {
    key = 'b',
    mods = 'CMD',
    action = actions.RotatePanes 'Clockwise',
  },
  {
    key = 'j',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, pane)
      local tab = window:active_tab()
      local vim_pane = find_vim_pane(tab)

      if is_vim(pane) then
        -- if only 1 pane exists and it is vim, split below
        if (#tab:panes()) == 1 then
          -- Open pane below if when there is only one pane and it is vim
          tab:set_zoomed(false)
          pane:split {
            direction = 'Bottom',
            size = 0.333,
          }
        else -- if there are multiple panes, toggle zooming/switching between them
          local is_zoomed = tab:panes_with_info()[1].is_zoomed
          if is_zoomed then
            tab:set_zoomed(false)
            -- activate the non-vim pane
            tab:get_pane_direction('Down'):activate()
          else
            tab:set_zoomed(true)
          end
        end
        return
      end

      -- Zoom to vim pane if it exists
      if vim_pane then
        vim_pane:activate()
        tab:set_zoomed(true)
      end
    end),
  },
}

-- F key tab navigation
for i = 1, 9 do
  local key = tostring(i)

  -- this is dumb but since wezterm cant successfully pass SUPER to nvim,
  -- convert SUPER to META for nvim only
  -- then nvim can watch the META key and i guess i have 2 keybinds for the same thng but whatever
  table.insert(Wez_Conf.keys, {
    key = key,
    mods = 'SUPER',
    action = wezterm.action_callback(function(win, pane)
      local mods = ''
      if pane:get_user_vars().IS_NVIM == 'true' then
        -- convert it to META key for nvim only
        mods = 'META'
      else
        -- pass through the normal SUPER key any other time
        mods = 'SUPER'
      end

      win:perform_action(actions.SendKey({ key = key, mods = mods }), pane)
    end),
  })

  -- add function key tab nav
  table.insert(Wez_Conf.keys, {
    key = 'F' .. key,
    action = actions.ActivateTab(i - 1),
  })
end

for i = 1, 8 do
  -- CTRL+ALT + number to move to that position
  table.insert(Wez_Conf.keys, {
    key = tostring(i),
    mods = 'CTRL|ALT',
    action = wezterm.action.MoveTab(i - 1),
  })
end

--
-- Mux pane navigation
---@param resize_or_move "resize" | "move"
---@param key "k" | "j" | "l" | ";" | "B" // tbh i forget what the B is for
---@param direction "Up" | "Down" | "Left" | "Right"
local function split_nav(resize_or_move, key, direction)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if pane:get_user_vars().IS_NVIM == 'true' then
        -- pass the keys through to vim/nvim
        if (key == ';') then
          key = 'B'
        end
        win:perform_action(actions.SendKey({ key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' }), pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action(actions.AdjustPaneSize({ direction, 3 }), pane)
        else
          win:perform_action(actions.ActivatePaneDirection(direction), pane)
        end
      end
    end),
  }
end

-- build up and apply the maps using the split_nav helper function
local pane_maps = {
  -- move between split panes
  split_nav('move', 'k', 'Up'),
  split_nav('move', 'j', 'Down'),
  split_nav('move', 'l', 'Right'),
  split_nav('move', ';', 'Left'),
  -- resize panes
  split_nav('resize', 'k', 'Up'),
  split_nav('resize', 'j', 'Down'),
  split_nav('resize', 'l', 'Right'),
  split_nav('resize', ';', 'Left'),
}
ConcatTables(Wez_Conf.keys, pane_maps)

--
-- Mux tab creation
--

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

    local title = label:gsub('%s%s%s.*', '')

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

    local current_tab_index = active_tab(window:mux_window()).index

    -- create new tab
    local new_tab, new_pane, _ = window:mux_window():spawn_tab { cwd = id }
    new_tab:set_title(label)
    window:perform_action(actions.MoveTab(current_tab_index), new_pane)

    -- close old tab
    window:perform_action(actions.ActivateTab(current_tab_index + 1), pane2)
    window:perform_action(actions.CloseCurrentTab { confirm = false }, pane2)

    -- ensure we're on the new tab again
    window:perform_action(actions.ActivateTab(current_tab_index), new_pane)
  end),
})

-- -- OMG
-- -- THEMES
-- wezterm.GLOBAL.currentSchemeIndex = (wezterm.GLOBAL.currentSchemeIndex or 0) + 1
--
--
-- -- warning this sets config overrides on the window
-- -- so like dont be surprised when your config is overridden on the window for like its whole life
-- local function themeCycler(window, _)
--   local allSchemes = wezterm.color.get_builtin_schemes()
--
--   local keyset = {}
--   local n = 0
--
--   for k, v in pairs(allSchemes) do
--     n = n + 1
--     keyset[n] = k
--   end
--
--   local index = wezterm.GLOBAL.currentSchemeIndex
--   local overrides = window:get_config_overrides() or {}
--   local new_scheme = keyset[index]
--   overrides.color_scheme = new_scheme
--   wezterm.log_info("Switched to: " .. new_scheme)
--   window:set_config_overrides(overrides)
-- end
--
-- -- add theme cycle keybind
-- table.insert(Wez_Conf.keys, { key = "t", mods = "ALT", action = wezterm.action_callback(themeCycler) })
