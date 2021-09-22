local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local pfp = wibox.widget {
   image = beautiful.pfp,
   resize = true,
   widget = wibox.widget.imagebox
}

local pfp_text = wibox.widget {
   markup = 'Welcome, Matei',
   align  = 'center',
   valign = 'center',
   widget = wibox.widget.textbox
}

local pfp_box = wibox {
  widget = pfp,
  width = dpi(100),
  height = dpi(100),
  visible = true,
  ontop = false,
  shape = gears.shape.rectangle,
  border_width = dpi(2),
  border_color = beautiful.border_color_normal,
  screen = awful.screen.focused()
}

awful.placement.centered(pfp_box)
