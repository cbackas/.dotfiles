local wezterm = require 'wezterm' --[[@as Wezterm]]
local actions = wezterm.action

-- this is dumb but since wezterm cant successfully pass SUPER to nvim,
-- convert SUPER to META for nvim only
-- then nvim can watch the META key and i guess i have 2 keybinds for the same thng but whatever
local function add_super_nav_key(key)
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
end

-- Super key nav
for i = 1, 9 do
  add_super_nav_key(tostring(i))
end
