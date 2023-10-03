-- general settings

Wez_Conf.front_end = "WebGpu"
Wez_Conf.freetype_load_target = "HorizontalLcd"
Wez_Conf.animation_fps = 60
Wez_Conf.max_fps = 120

Wez_Conf.scrollback_lines = 100000

-- use a unix domain so sessions outlast wezterm
Wez_Conf.unix_domains = {
  {
    name = 'unix',
    local_echo_threshold_ms = 10,
  },
}
-- enable unix domain socket by default
Wez_Conf.default_gui_startup_args = { 'connect', 'unix' }
