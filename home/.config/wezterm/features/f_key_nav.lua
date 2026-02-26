local wezterm = require 'wezterm' --[[@as Wezterm]]
local actions = wezterm.action

-- F key tab navigation
for i = 1, 9 do
  -- add function key tab nav
  table.insert(Wez_Conf.keys, {
    key = 'F' .. tostring(i),
    action = actions.ActivateTab(i - 1),
  })
end

for i = 1, 9 do
  -- CTRL+ALT + number to move to that position
  table.insert(Wez_Conf.keys, {
    key = tostring(i),
    mods = 'CTRL|ALT',
    action = wezterm.action.MoveTab(i - 1),
  })
end
