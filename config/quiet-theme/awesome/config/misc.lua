-- Standard awesome library
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

-- Misc libraries
local bling = require("modules.bling")
local machi = require("modules.layout-machi")

-- Layouts
awful.layout.layouts = {
    awful.layout.suit.fair,
    awful.layout.suit.tile,
    bling.layout.centered,
    bling.layout.deck,
    bling.layout.equalarea,
    bling.layout.mstab,
    awful.layout.suit.floating,
    machi.default_layout,
}

beautiful.layout_machi = machi.get_icon()

machi.editor.nested_layouts = {
    ["1"] = bling.layout.centered,
    ["2"] = bling.layout.deck,
    ["3"] = bling.layout.equalarea,
    ["4"] = bling.layout.mstab,
}

--bling.module.wallpaper.setup {
--  wallpaper = {"/home/matei/Pictures/Wallpaper/Coast.jpg"},
--  position = "maximized",
--}

awful.screen.connect_for_each_screen(function(s)
    bling.module.tiled_wallpaper("", s, {
        fg = "#1f252a",
        bg = "#0b1116",
        offset_y = 0,
        offset_x = 0,
        font = "Iosevka Nerd Font",
        font_size = 12,
        padding = 75,
        zickzack = true
    })
end)

-- Flash focus
bling.module.flash_focus.disable()
