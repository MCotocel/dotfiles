pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Theme handling library
local beautiful = require("beautiful")
-- Themes. Currently using Quiet theme, a theme of my own creation
beautiful.init(gears.filesystem.get_configuration_dir() .. "quiet/theme.lua")

-- Notification library
local naughty = require("naughty")

-- Declarative object management
local revelation = require("modules.awesome-revelation")

revelation.init()
revelation.charorder = "1234567890qwertyuiopasdfghjklzxcvbnm"

-- Hotkey help for other apps
require("awful.hotkeys_popup.keys")

-- Send a notification if an error occured
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "An error occured"..(startup and " during startup"),
        message = message
    }
end)

-- Autostart stuff
awful.spawn.with_shell("~/.config/awesome/autorun.sh")

terminal = "wezterm" -- Lua superiority
editor = os.getenv("EDITOR") or "vim" -- Lisp superiority (my default editor is emacs)
editor_cmd = "emacsclient -c" -- Lisp superiority

-- Super key as mod key. Windows key for you window plebians
modkey = "Mod4"

-- Keybindings
require("config.keys")

-- Bar config
require("config.bar")

-- Titlebar config
require("config.titlebar")

-- Rules config
require("config.rules")

-- Misc config
require("config.misc")

-- Widgets
require("widgets.brightness")
require("widgets.volume")
--require("widgets.pfp")

-- Battery warning
require("config.battery-warning")

-- Layout switcher
require("config.layout")
