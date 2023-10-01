local wezterm = require 'wezterm'

-- In newer versions of wezterm, use the Wez_Conf_builder which will
-- help provide clearer error messages
_G.Wez_Conf = {} -- global config variable
if wezterm.Wez_Conf_builder then
  Wez_Conf = wezterm.config_builder()
end

-- Wez_Conf is modified in the following files
require("set")
require("appearance")
require("remap")

return Wez_Conf
