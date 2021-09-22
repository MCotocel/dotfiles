pcall(require, "luarocks.loader")

-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")

-- Theme handling library
local beautiful = require("beautiful")

-- Hotkey help for other apps
require("awful.hotkeys_popup.keys")

-- Rules
awful.rules.rules = {
    -- All clients will match this rule
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            maximized_vertical = false,
            maximized_horizontal = false,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap +
            awful.placement.no_offscreen,
            titlebars_enabled = false
        }
    }, -- Floating clients.
    {
        rule_any = {
            class = {
                "Gpick", "Tor Browser", "Gimp"
            }
        },
        properties = {
            floating = true
        }
    }
}
