local wezterm = require 'wezterm'
local actions = wezterm.action

-- keys
Wez_Conf.leader = { key = ' ', mods = 'CTRL', timeout_milliseconds = 1000 }
Wez_Conf.keys = {
  { key = 'L', mods = 'CTRL', action = actions.ShowDebugOverlay },
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
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
}

-- F key tab navigation
for i = 1, 9 do
  table.insert(Wez_Conf.keys, {
    key = 'F' .. tostring(i),
    action = actions.ActivateTab(i - 1),
  })
end

--
-- Mux pane navigation
--

local function split_nav(resize_or_move, key, direction)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if pane:get_user_vars().IS_NVIM == 'true' then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction, 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction }, pane)
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
  local cmd = "ls -d " .. path .. "/*/ 2>/dev/null"
  local dirs = {}
  local pfile = io.popen(cmd)
  if not pfile then
    return dirs
  end

  for dir in pfile:lines() do
    local dir_name = dir:match("([^/]+)/?$") -- Extract the last part of the path
    table.insert(dirs, { label = prefix .. dir_name, id = path .. "/" .. dir_name })
  end

  pfile:close()
  return dirs
end

-- keybind to open project fuzzy selector
-- when you select an option it will switch to that project's tab if it exists or spawn a new one
table.insert(Wez_Conf.keys, {
  key = 'P',
  mods = 'SUPER|SHIFT',
  action = wezterm.action_callback(function(window, pane)
    local choices = get_directory_choices(os.getenv('HOME') .. '/Projects')
    ConcatTables(choices, get_directory_choices(os.getenv('HOME') .. '/.dotfiles/home/.config', 'conf'))

    window:perform_action(
      wezterm.action.InputSelector {
        action = wezterm.action_callback(function(window2, _pane, id, label)
          if not id and not label then
            wezterm.log_error 'cancelled'
            return
          end

          local mux_window = window2:mux_window()
          for _, tab in pairs(mux_window:tabs()) do
            local tab_title = tab:get_title()
            if tab_title == label then
              wezterm.log_info('switching to tab: ' .. label)
              tab:activate()
              return
            end
          end

          wezterm.log_info('spawning new tab: ' .. label)
          local tab, _pane, _window = mux_window:spawn_tab { cwd = id }
          tab:set_title(label)
        end),
        title = 'Which project would you like to open?',
        choices = choices,
        fuzzy = true
      },
      pane
    )
  end),
})
