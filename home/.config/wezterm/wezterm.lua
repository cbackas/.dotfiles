local wezterm = require('wezterm') --[[@as Wezterm]]

-- Wez_Conf is a global variable that holds all the configuration
_G.Wez_Conf = wezterm.config_builder()

require('global_utils')

-- build up the Wez_Conf values from the other files
require("settings")
require("appearance")

require("remap_keys")
require("remap_mouse")

require("features/f_key_nav")
require("features/project_picker")
require("features/mux_pane_nav")
require("features/toggle_term")

--- uncomment to enable theme picker
-- require("features/theme_picker")

-- This cast is needed for other config files to end up using the proper WezTerm
-- types rather than the type of the value returned by this file
return Wez_Conf
