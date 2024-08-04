local wezterm = require 'wezterm'

-- Wez_Conf is a global variable that holds all the configuration
---@class _.wezterm.ConfigBuilder
_G.Wez_Conf = wezterm.config_builder()

require('global_utils')

-- build up the Wez_Conf values from the other files
require("set")
require("appearance")
require("remap")

-- This cast is needed for other config files to end up using the proper WezTerm
-- types rather than the type of the value returned by this file
---@cast Wez_Conf WezTerm
return Wez_Conf
