local wezterm = require 'wezterm' --[[@as Wezterm]]

wezterm.GLOBAL.currentSchemeIndex = (wezterm.GLOBAL.currentSchemeIndex or 0) + 1


-- warning this sets config overrides on the window
-- so like dont be surprised when your config is overridden on the window for like its whole life
local function themeCycler(window, _)
  local allSchemes = wezterm.color.get_builtin_schemes()

  local keyset = {}
  local n = 0

  for k, _ in pairs(allSchemes) do
    n = n + 1
    keyset[n] = k
  end

  local index = wezterm.GLOBAL.currentSchemeIndex
  local overrides = window:get_config_overrides() or {}
  local new_scheme = keyset[index]
  overrides.color_scheme = new_scheme
  wezterm.log_info("Switched to: " .. new_scheme)
  window:set_config_overrides(overrides)
end

-- add theme cycle keybind
table.insert(Wez_Conf.keys, { key = "t", mods = "ALT", action = wezterm.action_callback(themeCycler) })
