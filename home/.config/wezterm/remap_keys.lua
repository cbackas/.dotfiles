local wezterm = require 'wezterm' --[[@as Wezterm]]
local actions = wezterm.action

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
  }
}
