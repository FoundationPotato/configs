local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font_size = 12

config.enable_tab_bar = false

config.color_scheme = 'Catppuccin Macchiato'

return config
