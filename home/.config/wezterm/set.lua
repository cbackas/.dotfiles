-- general settings

Wez_Conf.front_end = "WebGpu"
Wez_Conf.webgpu_power_preference = "HighPerformance"
Wez_Conf.freetype_load_target = "HorizontalLcd"
Wez_Conf.animation_fps = 60
Wez_Conf.max_fps = 120

Wez_Conf.scrollback_lines = 10000

-- use a unix domain so sessions outlast wezterm
Wez_Conf.unix_domains = {
  {
    name = 'unix',
    local_echo_threshold_ms = 10,
  },
}
-- enable unix domain socket by default
-- Wez_Conf.default_gui_startup_args = { 'connect', 'unix' }

Wez_Conf.enable_kitty_keyboard = true
Wez_Conf.enable_csi_u_key_encoding = false
Wez_Conf.debug_key_events = false
