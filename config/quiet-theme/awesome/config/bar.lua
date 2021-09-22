pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

-- Declarative object management
local hotkeys_popup = require("awful.hotkeys_popup")
local bling = require("modules.bling")

bling.widget.tag_preview.enable {
    show_client_content = true,
    x = 0,
    y = 0,
    scale = 0.25,
    honor_padding = false,
    honor_workarea = false,
    placement_fn = function(c)
        awful.placement.bottom_left(c, {
            margins = {
                bottom = 40,
                left = 30
            }
        })
    end
}

bling.widget.task_preview.enable {
    x = dpi(20),
    y = dpi(20),
    height = dpi(200),
    width = dpi(200),
    placement_fn = function(c)
        awful.placement.bottom(c, {
            margins = {
                bottom = dpi(40)
            }
        })
    end
}

awful.screen.connect_for_each_screen(function(s)

    -- Set tags and default layout
    awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.suit.fair)

    -- Show currently used layout
    local layoutbox = awful.widget.layoutbox(s)

    layoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end)
    ))

    local taglist_buttons = gears.table.join(
        awful.button({}, 1, function(t) t:view_only() end),
        awful.button({}, 2, function(t) client.focus:move_to_tag(t) end),
        awful.button({}, 3, function(t) awful.tag.viewtoggle(t) end))

    local taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = {
            shape = gears.shape.rect
        },
        layout = {
            spacing = dpi(5),
            spacing_widget = {
                color = beautiful.bg_diff,
                widget = wibox.widget.separator
            },
            layout = wibox.layout.fixed.horizontal
        },
        shape = gears.shape.rounded_rect,
        widget_template = {
            {
                {
                    {
                        {
                            {
                                id = 'text_role',
                                widget = wibox.widget.textbox,
                            },
                            margins = dpi(0),
                            widget = wibox.container.margin,
                        },
                        widget = wibox.container.background,
                    },
                    {
                        id = 'index_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = dpi(5),
                right = dpi(5),
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background,
            create_callback = function(self, c3, index, objects)
                self:connect_signal('mouse::enter', function()
                    if #c3:clients() > 0 then
                        awesome.emit_signal("bling::tag_preview::update", c3)
                        awesome.emit_signal("bling::tag_preview::visibility", s, true)
                    end
                end)
                self:connect_signal('mouse::leave', function()
                    awesome.emit_signal("bling::tag_preview::visibility", s, false)
                    if self.has_backup then self.bg = self.backup end
                end)
            end,
            update_callback = function(self, c3, index, objects)
            end,
        },
        buttons = taglist_buttons
    }

    local taglist_container = {
        taglist,
        left = dpi(3),
        right = dpi(3),
        bg = "#181e23",
        widget = wibox.container.margin
    }

    local final_taglist = wibox.widget {
        {
            taglist_container,
            top = dpi(3),
            bottom = dpi(3),
            left = dpi(3),
            right = dpi(3),
            layout = wibox.container.margin
        },
        bg = "#181e23",
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background
    }

    local tasklist_buttons = gears.table.join(
        awful.button({}, 1, function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", {raise = true})
        end end),
        awful.button({}, 3, function() awful.menu.client_list({theme = {width = 250}}) end),
        awful.button({}, 2, function() awful.client.focus.byidx(1) end))

    local tasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        widget_template = {
            {
                {
                    id = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = dpi(3),
                widget = wibox.container.margin
            },
            nil,
            create_callback = function(self, c, index, objects)
                self:get_children_by_id('clienticon')[1].client = c
                self:connect_signal('mouse::enter', function()
                        awesome.emit_signal("bling::task_preview::visibility", s,
                                            true, c)
                    end)
                    self:connect_signal('mouse::leave', function()
                        awesome.emit_signal("bling::task_preview::visibility", s,
                                            false, c)
                    end)
            end,
            layout = wibox.layout.align.vertical,
        },
    }

    local tasklist_container = {
        tasklist,
        left = dpi(3),
        right = dpi(3),
        bg = "#181e23",
        widget = wibox.container.margin
    }

    local final_tasklist = wibox.widget {
        {
            tasklist_container,
            top = dpi(3),
            bottom = dpi(3),
            left = dpi(3),
            right = dpi(3),
            layout = wibox.container.margin
        },
        bg = "#181e23",
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background
    }

    -- Add nice background to systray

    local systray = wibox.widget.systray()
    systray:set_base_size(beautiful.systray_icon_size)

    local systray_container = {
        systray,
        left = dpi(8),
        right = dpi(8),
        bg = "#181e23",
        widget = wibox.container.margin
    }

    local final_systray = wibox.widget {
        {
            systray_container,
            top = dpi(6),
            bottom = dpi(6),
            left = dpi(3),
            right = dpi(3),
            layout = wibox.container.margin
        },
        bg = "#181e23",
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background
    }

    -- Clock
    local clock = wibox.widget.textclock()

    local clock_container = {
        clock,
        left = dpi(8),
        right = dpi(8),
        bg = "#181e23",
        widget = wibox.container.margin
    }

    local final_clock = wibox.widget {
        {
            clock_container,
            top = dpi(6),
            bottom = dpi(6),
            left = dpi(3),
            right = dpi(3),
            layout = wibox.container.margin
        },
        bg = "#181e23",
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background
    }

    -- Battery
    local battery = awful.widget.watch('bash -c "echo Battery: `cat /sys/class/power_supply/BAT0/capacity`%"', 15)

    local battery_container = {
        battery,
        left = dpi(8),
        right = dpi(8),
        bg = "#181e23",
        widget = wibox.container.margin
    }

    local final_battery = wibox.widget {
        {
            battery_container,
            top = dpi(6),
            bottom = dpi(6),
            left = dpi(3),
            right = dpi(3),
            layout = wibox.container.margin
        },
        bg = "#181e23",
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background
    }

    local battery_tooltip = awful.tooltip
    {
        objects = { battery },
        timer_function = function()
            return io.popen("bash -c \"echo -n Status: `cat /sys/class/power_supply/BAT0/status`\""):read("*a")
        end,
        timeout = 0,
        bg = beautiful.bg_diff,
        align = "top_left",
        margins = dpi(5)
    }

    -- Menu
    local awesomemenu = {
     {"Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
     {"Reload", awesome.restart},
     {"Quit", function() awesome.quit() end},
    }

    local appmenu = {
     {"Terminal", function() awful.spawn.with_shell("wezterm") end},
     {"Editor", function() awful.spawn.with_shell("emacsclient -c") end},
     {"Browser", function() awful.spawn.with_shell("firefox") end},
     {"Music", function() awful.spawn.with_shell("spotify") end},
     {"File manager", function() awful.spawn.with_shell("thunar") end},
    }

    local scriptmenu = {
     {"Take screenshot", function() awful.spawn.with_shell("~/.bin/rofi-screenshot") end},
     {"Image to text", function() awful.spawn.with_shell("~/.bin/rofi-imgtext") end},
     {"Shorten url", function() awful.spawn.with_shell("~/.bin/rofi-urlshorten") end},
    }

    local mainmenu = awful.menu({items = {
        {"AwesomeWM", awesomemenu, beautiful.awesome_icon},
        {"Scripts", scriptmenu, beautiful.terminal},
        {"Apps", appmenu, beautiful.app},
    }})

    local launcher = awful.widget.launcher({image = beautiful.ghost, menu = mainmenu})

    -- Create the wibar
    s.wibar = awful.wibar({
        position = "bottom",
        x = dpi(0),
        y = dpi(0),
        screen = s,
        height = dpi(35),
        visible = true,
        stretch = true,
    })

    -- Add widgets
    s.wibar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            launcher,
            wibox.layout.margin(final_taglist, dpi(3), dpi(3), dpi(3), dpi(3)),
        },
        {
            layout = wibox.layout.fixed.horizontal,
            {
                wibox.layout.margin(final_tasklist, dpi(3), dpi(3), dpi(3), dpi(3)),
                widget = wibox.container.background
            }
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.layout.margin(final_clock, dpi(3), dpi(3), dpi(3), dpi(3)),
            wibox.layout.margin(final_battery, dpi(3), dpi(3), dpi(3), dpi(3)),
            wibox.layout.margin(final_systray, dpi(3), dpi(3), dpi(3), dpi(3)),
            wibox.layout.margin(layoutbox, dpi(7), dpi(7), dpi(7), dpi(7))
        },
    }
end)
