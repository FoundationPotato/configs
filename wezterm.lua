local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font_size = 12
config.font = wezterm.font('IBMPlexMono')

config.window_decorations = "RESIZE"

config.enable_tab_bar = false

-- config.color_scheme = "tokyonight_night"
config.color_scheme = "OneDark (base16)"

return config
