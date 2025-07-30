local wezterm = require 'wezterm' --[[@as Wezterm]]

local is_linux = wezterm.target_triple == 'x86_64-unknown-linux-gnu'

-- fonts
Wez_Conf.font = wezterm.font_with_fallback({
  "Berkeley Mono",
  "Monaspace Neon",
  "Hack Nerd Font Mono"
})
Wez_Conf.font_size = 14.7

-- colors
-- Wez_Conf.color_scheme = 'WildCherry'
-- Wez_Conf.color_scheme = 'Modus-Vivendi-Tinted'

local my_theme = wezterm.color.get_builtin_schemes()['Modus-Vivendi-Tinted']
my_theme.cursor_bg = "#808080"

Wez_Conf.color_schemes = {
  ['My-Modus-Vivendi-Tinted'] = my_theme,
}
Wez_Conf.color_scheme = 'My-Modus-Vivendi-Tinted'

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

if is_linux then
  Wez_Conf.enable_wayland = false
end
