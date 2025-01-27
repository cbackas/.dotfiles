local wezterm = require 'wezterm' --[[@as Wezterm]]
local actions = wezterm.action

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
