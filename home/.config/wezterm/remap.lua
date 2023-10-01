local wezterm = require 'wezterm'
local actions = wezterm.action

-- keys
Wez_Conf.leader = { key = ' ', mods = 'CTRL', timeout_milliseconds = 1000 }
Wez_Conf.keys = {
  {
    key = '\\',
    mods = 'LEADER',
    action = actions.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = actions.SplitPane {
      direction = 'Down',
      size = { Percent = 50 },
    },
  },
  {
    key = '_',
    mods = 'LEADER|SHIFT',
    action = actions.SplitPane {
      direction = 'Down',
      size = { Percent = 30 },
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
