local awful = require("awful")
require("awful.autofocus")

local hotkeys_popup = require("awful.hotkeys_popup")

local bling = require("modules.bling")
local machi = require("modules.layout-machi")
local revelation = require("modules.awesome-revelation")

-- Mouse Bindings
awful.mouse.append_global_mousebindings({
    awful.button({}, 8, awful.tag.viewprev),
    awful.button({}, 9, awful.tag.viewnext)
})

awful.keyboard.append_global_keybindings({

--- AwesomeWM ---

-- Toggle titlebar
awful.key({modkey}, '`', function() awful.titlebar.toggle(client.focus) end, {
    description = "Toggle title bar", group = "AwesomeWM"
}),

-- Edit the current layout
awful.key({modkey}, "'", function() machi.default_editor.start_interactive() end, {
    description = "Edit the current layout",
    group = "Machi"
}),

-- Switch windows in Machi layout
awful.key({modkey}, ".", function() machi.switcher.start(client.focus) end, {
    description = "Switch windows in Machi layout",
    group = "Machi"
}),

-- Toggle Wibar
awful.key({modkey}, "b", function()
      for s in screen do s.wibar.visible = not s.wibar.visible end
    end, {
    description = 'Togkle Wibar', group = "AwesomeWM"
}),

-- Expose
awful.key({modkey}, "e", revelation, {
    description = 'Expose', group = "AwesomeWM"
}),

--- Bling ---

-- Toggle swallowing
awful.key({modkey}, 's', function() bling.module.window_swallowing.toggle() end, {
   description = 'Toggle swallowing', group = "Bling"
}),

-- Add client to tabbed layout
awful.key({modkey}, 't', function() bling.module.tabbed.pick() end, {
   description = 'Add client to tabbed layout', group = "Bling"
}),

-- Tab through clients in tabbed client
awful.key({modkey}, 'Tab', function() bling.module.tabbed.iter() end, {
   description = 'Tab through clients in tabbed client', group = "Bling"
}),

--- Tags ---

-- Previous tag
awful.key({modkey}, "Left", awful.tag.viewprev, {
    description = "Previous Tag",
    group = "Tags"
}),

-- Next Tag
awful.key({modkey}, "Right", awful.tag.viewnext, {
    description = "Next Tag",
    group = "Tags"
}),

-- View desktop
awful.key({modkey}, "d", function() awful.tag.viewnone() end, {
    description = "View desktop",
    group = "Tags"
}),

--- Windows ---

-- Toggle floating mode
awful.key({modkey, "Control"}, "space", awful.client.floating.toggle, {
    description = "Toggle floating mode",
    group = "Windows"
}),

-- Toggle Fullscreen
awful.key({modkey, "Shift"}, "f", function()
        client.focus.fullscreen = not client.focus.fullscreen client.focus:raise()
    end, {
    description = "Toggle fullscreen mode",
    group = "Windows"
}),

-- Close window
awful.key({modkey, "Shift"}, "q", function() client.focus:kill() end, {
    description = "Close window",
    group = "Windows"
}),

-- Focus left
awful.key({modkey}, "h", function() awful.client.focus.bydirection("left") end, {
    description = "Focus left",
    group = "Windows"
}),

-- Focus down
awful.key({modkey}, "j", function() awful.client.focus.bydirection("down") end, {
    description = "Focus down",
    group = "Windows"
}),

-- Focus up
awful.key({modkey}, "k", function() awful.client.focus.bydirection("up") end, {
    description = "Focus up",
    group = "Windows"
}),

-- Focus right
awful.key({modkey}, "l", function() awful.client.focus.bydirection("right") end, {
    description = "Focus right",
    group = "Windows"
}),

-- Swap with next client
awful.key({modkey, "Control"}, "j", function() awful.client.swap.byidx(1) end, {
    description = "Swap with next client",
    group = "Windows"
}),

-- Swap with previous client
awful.key({modkey, "Control"}, "k", function() awful.client.swap.byidx(-1) end, {
    description = "Swap with previous client",
    group = "Windows"
}),

-- Resize to the right
awful.key({modkey, "Shift"}, "l", function() awful.tag.incmwfact(0.05) end, {
    description = "Resize to the right",
    group = "Windows"
}),

-- Resize to the left
awful.key({modkey, "Shift"}, "h", function() awful.tag.incmwfact(-0.05) end, {
    description = "Resize to the left",
    group = "Windows"
}),

-- Minimize windows
awful.key({modkey}, "m", function() client.focus.minimized = true end, {
    description = "Minimize windows",
    group = "Windows"
}),

-- Un-minimize windows
awful.key({modkey, "Control"}, "m", function () local c = awful.client.restore() if c then c:activate { raise = true, context = "key.unminimize" } end end, {
     description = "Un-minimize windows",
     group = "Windows"
}),

awful.key({modkey}, "c", function(c) awful.client.floating.set(c, true) awful.placement.centered(c) end, {
     description = "Center window",
     group = "Windows"
}),

--- Applications and menus --

-- Open terminal
awful.key({modkey}, "Return", function() awful.spawn(terminal) end, {
    description = "Open terminal",
    group = "Applications and menus"
}),

-- Open launcher
awful.key({modkey}, "space", function() awful.spawn.with_shell("rofi -show drun -display-drun 'App Launcher'") end, {
    description = "Open launcher",
    group = "Applications and menus"
}),

-- Open emacs
awful.key({modkey, "Shift"}, "e", function() awful.spawn.with_shell("emacsclient -c") end, {
    description = "Open emacs",
    group = "Applications and menus"
}),

-- Open feed reader
awful.key({modkey, "Shift"}, "r", function() awful.spawn.with_shell("emacsclient -c -e '(elfeed)'") end, {
    description = "Open feed reader",
    group = "Applications and menus"
}),

-- Take screenshot
awful.key({modkey, "Shift"}, "s", function() awful.spawn.with_shell("~/.bin/rofi-screenshot") end, {
    description = "Take screenshot",
    group = "Applications and menus"
}),

-- Power menu
awful.key({modkey}, "Escape", function() awful.spawn.with_shell("~/.bin/rofi-power") end, {
    description = "Power menu",
    group = "Applications and menus"
}),

-- Lock screen
awful.key({}, "XF86Sleep", function() awful.spawn.with_shell("~/.bin/lock") end, {
    description = "Power menu",
    group = "Applications and menus"
}),

-- Hotkey menu
awful.key({modkey}, "/", hotkeys_popup.show_help, {
    description = "Hotkey menu",
    group = "Applications and menus"
}),

-- Various functions

-- Volume up
awful.key({}, "XF86AudioRaiseVolume", function()
      awesome.emit_signal("volume_change")
      awful.spawn.with_shell("pactl set-sink-volume 0 +1%")
      end, {
      description = "Volume up",
      group = "Various functions"
}),

-- Volume down
awful.key({}, "XF86AudioLowerVolume", function()
      awesome.emit_signal("volume_change")
      awful.spawn.with_shell("pactl set-sink-volume 0 -1%")
      end, {
      description = "Volume down",
      group = "Various functions"
}),

-- Toggle mute
awful.key({}, "XF86AudioMute", function()
      awesome.emit_signal("volume_change")
      awful.spawn.with_shell("pactl set-sink-mute 0 toggle")
      end, {
      description = "Toggle mute",
      group = "Various functions"
}),

-- Next song
awful.key({modkey}, "XF86AudioRaiseVolume", function()
      awful.spawn.with_shell("playerctl next")
      end, {
      description = "Next song",
      group = "Various functions"
}),

-- Previous song
awful.key({modkey}, "XF86AudioLowerVolume", function()
      awful.spawn.with_shell("playerctl previous")
      end, {
      description = "Previous song",
      group = "Various functions"
}),

-- Toggle song
awful.key({modkey}, "XF86AudioMute", function()
      awful.spawn.with_shell("playerctl play-pause")
      end, {
      description = "Toggle song",
      group = "Various functions"
}),

-- Brightness up
awful.key({}, "XF86MonBrightnessUp", function()
      awesome.emit_signal("backlight_change")
      awful.spawn.with_shell("brightnessctl s +1%")
      end, {
      description = "Brightness up",
      group = "Various functions"
}),

-- Brightness down
awful.key({}, "XF86MonBrightnessDown", function()
      awesome.emit_signal("backlight_change")
      awful.spawn.with_shell("brightnessctl s 1%-")
      end, {
      description = "Brightness down",
      group = "Various functions"
})})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({modkey}, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({modkey}, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers = { modkey },
        keygroup = "numrow",
        description = "Only view tag",
        group = "Tag",
        on_press = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Control" },
        keygroup = "numrow",
        description = "Toggle tag",
        group = "Tags",
        on_press = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup = "numrow",
        description = "Move focused client to tag",
        group = "Tags",
        on_press = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
}})
