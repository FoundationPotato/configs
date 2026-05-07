local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.window_decorations = "TITLE | RESIZE"

config.font_size = 12
config.font = wezterm.font('JetBrains Mono')
config.color_scheme = "OneDark (base16)"

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

local scheme = wezterm.color.get_builtin_schemes()['OneDark (base16)']
config.colors = {
    tab_bar = {
        background = scheme.background,
        active_tab = {
            bg_color = scheme.background,
            fg_color = scheme.ansi[5],
        },
        inactive_tab = {
            bg_color = scheme.background,
            fg_color = scheme.foreground,
        },
    },
}

wezterm.on('update-right-status', function (window)
    local time = wezterm.strftime '%H:%M '
    window:set_right_status(wezterm.format {
        { Text = time },
    })
end)

config.keys = {
    -- Create pane
    {
        key = '-',
        mods = 'CTRL',
        action = wezterm.action.SplitPane {
            direction = 'Down',
        },
    },
    {
        key = '\\',
        mods = 'CTRL',
        action = wezterm.action.SplitPane {
            direction = 'Right',
        },
    },
    -- Close current pane
    {
        key = 'x',
        mods = 'CTRL',
        action = wezterm.action.CloseCurrentPane {confirm = true},
    },
    -- Close current tab
    {
        key = 'X',
        mods = 'CTRL',
        action = wezterm.action.CloseCurrentTab {confirm = true},
    },
}

return config
