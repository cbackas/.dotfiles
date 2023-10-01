local wezterm = require 'wezterm'

-- fonts
Wez_Conf.font = wezterm.font "Berkeley Mono"
Wez_Conf.font_size = 14.5

-- colors
Wez_Conf.color_scheme = 'midnight-in-mojave'

-- tab bar
Wez_Conf.enable_tab_bar = true
Wez_Conf.tab_bar_at_bottom = true
Wez_Conf.use_fancy_tab_bar = false

-- window
Wez_Conf.enable_scroll_bar = true
Wez_Conf.window_padding = {
  left = 0,
  right = 4,
  top = 0,
  bottom = 0,
}
