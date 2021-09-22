local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local backlight_bar = wibox.widget {
    max_value = 100,
    value = 0,
    forced_height = dpi(20),
    margins = {top = dpi(5), bottom = dpi(5), left = dpi(5), right = dpi(5)},
    forced_width = dpi(200),
    shape = gears.shape.rounded_rect,
    bar_shape = gears.shape.rounded_rect,
    color = beautiful.bg_diff,
    background_color = beautiful.bg_normal,
    border_width = dpi(2),
    border_color = beautiful.border_color_normal,
    widget = wibox.widget.progressbar
}

local backlight_box = wibox {
  widget = backlight_bar,
  width = dpi(250),
  height = dpi(30),
  visible = false,
  ontop = true,
  shape = gears.shape.rectangle,
  border_width = dpi(2),
  border_color = beautiful.border_color_normal,
  screen = awful.screen.focused()
}

local hide_backlight_box = gears.timer {
   timeout = 0.7,
   autostart = true,
   callback = function()
      backlight_box.visible = false
   end
}

awful.placement.top(backlight_box)

awesome.connect_signal("backlight_change",
   function()
      awful.spawn.easy_async_with_shell(
         "brightnessctl | grep -o '...%' | sed 's/(//g' | sed 's/%//g'",
         function(stdout)
            local backlight_level = tonumber(stdout)
            backlight_bar.value = backlight_level
         end,
         false
      )

      if backlight_box.visible then
         hide_backlight_box:again()
      else
         backlight_box.visible = true
         hide_backlight_box:start()
      end
   end
)
