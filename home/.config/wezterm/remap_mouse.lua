local wezterm = require 'wezterm'
local actions = wezterm.action

Wez_Conf.mouse_bindings = {
  -- Disable the default click behavior
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = actions.DisableDefaultAssignment,
  },
  -- Cmd-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = actions.OpenLinkAtMouseCursor,
  },
  -- Disable the Cmd-click down event to stop programs from seeing it when a URL is clicked
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = actions.Nop,
  },
}
