local wezterm = require('wezterm') --[[@as Wezterm]]

-- Wez_Conf is a global variable that holds all the configuration
_G.Wez_Conf = wezterm.config_builder()

require('global_utils')

-- build up the Wez_Conf values from the other files
require("set")
require("appearance")
require("remap_keys")
require("remap_mouse")

-- This cast is needed for other config files to end up using the proper WezTerm
-- types rather than the type of the value returned by this file
return Wez_Conf
