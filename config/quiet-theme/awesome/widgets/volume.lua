local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local volume_bar = wibox.widget {
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

local volume_box = wibox {
  widget = volume_bar,
  width = dpi(250),
  height = dpi(30),
  visible = false,
  ontop = true,
  shape = gears.shape.rectangle,
  border_width = dpi(2),
  border_color = beautiful.border_color_normal,
  screen = awful.screen.focused()
}

local hide_volume_box = gears.timer {
   timeout = 0.7,
   autostart = true,
   callback = function()
      volume_box.visible = false
   end
}

awful.placement.top(volume_box)

awesome.connect_signal("volume_change",
   function()
      awful.spawn.easy_async_with_shell(
         "pamixer --get-volume",
         function(stdout)
            local volume_level = tonumber(stdout)
            volume_bar.value = volume_level
         end,
         false)
      awful.spawn.easy_async_with_shell(
         "pamixer --get-mute",
         function(stdout)
            local volume_state = stdout
            if volume_state == "false\n" then
                volume_bar.color = beautiful.bg_normal
            elseif volume_state == "true\n" then
                volume_bar.color = beautiful.bg_diff
            end
         end,
         false
      )

      if volume_box.visible then
         hide_volume_box:again()
      else
         volume_box.visible = true
         hide_volume_box:start()
      end
   end
)
