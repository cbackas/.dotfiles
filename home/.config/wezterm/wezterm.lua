local wezterm = require 'wezterm'

-- Wez_Conf is a global variable that holds all the configuration
_G.Wez_Conf = wezterm.config_builder()

-- build up the Wez_Conf values from the other files
require("set")
require("appearance")
require("remap")

return Wez_Conf
