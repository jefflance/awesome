----------------
-- Gune theme --
----------------

-- {{{ Required libraries calls
local awful = require("awful")
local gears = require("gears")
local lain  = require("lain")
local wibox = require("wibox")
local os = { getenv = os.getenv, setlocale = os.setlocale }
local my_table = awful.util.table or gears.table
-- }}}



-- {{{ Variables definitions
local theme = {}

theme.dir           = os.getenv("HOME") .. "/.config/awesome/themes/gune"
theme.wallpaper     = theme.dir .. "/wall.jpg"

theme.font          = "Roboto 12"

theme.bg_normal     = "#272935"
theme.bg_focus      = theme.bg_normal
theme.bg_urgent     = theme.bg_normal
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#dadce8"
theme.fg_focus      = "#FF79C6"	-- "#CF9367"
theme.fg_urgent     = "#EFF579" -- "#2C7CC2"
theme.fg_minimize   = theme.fg_normal

theme.notification_fg           = "#ffffff"
theme.notification_bg           = theme.bg_focus
theme.notification_border_color = theme.bg_normal
theme.notification_opacity      = 80

theme.prompt_fg = theme.fg_urgent
theme.prompt_bg = theme.bg_focus

theme.useless_gap   = 5
theme.border_width  = 5
theme.border_normal = "#272935"
theme.border_focus  = "#000000"
theme.border_marked = "#ffffff"

theme.titlebar_bg_focus    = theme.bg_focus
theme.titlebar_fg_focus    = theme.fg_focus

theme.tasklist_font        = "Roboto 12"
theme.tasklist_font_focus  = "Roboto 12 bold"
theme.tasklist_bg_focus    = theme.bg_focus
theme.tasklist_fg_focus    = "#EFF579" -- theme.fg_focus

theme.taglist_font          = "Roboto 12 bold"
-- theme.taglist_font_focus    = "Roboto 12 bold"
theme.taglist_bg_focus      = theme.bg_normal
theme.taglist_fg_focus      = theme.fg_focus

theme.tooltip_bg_focus      = theme.bg_focus
theme.tooltip_fg_focus      = theme.fg_focus
theme.tooltip_border_color  = theme.bg_normal

theme.hotkeys_group_margin  = "10"

theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"
-- awful.util.tagnames         = { "mail", "web", "term", "file", "steam" }

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height       = 24
theme.menu_width        = 200

-- Define the image to load
theme.titlebar_close_button_normal              = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = "/usr/share/awesome/themes/default/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal           = "/usr/share/awesome/themes/default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = "/usr/share/awesome/themes/default/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive     = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh      = "/usr/share/awesome/themes/default/layouts/fairhw.png"
theme.layout_fairv      = "/usr/share/awesome/themes/default/layouts/fairvw.png"
theme.layout_floating   = "/usr/share/awesome/themes/default/layouts/floatingw.png"
theme.layout_magnifier  = "/usr/share/awesome/themes/default/layouts/magnifierw.png"
theme.layout_max        = "/usr/share/awesome/themes/default/layouts/maxw.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/default/layouts/tilebottomw.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/default/layouts/tileleftw.png"
theme.layout_tile       = "/usr/share/awesome/themes/default/layouts/tilew.png"
theme.layout_tiletop    = "/usr/share/awesome/themes/default/layouts/tiletopw.png"
theme.layout_spiral     = "/usr/share/awesome/themes/default/layouts/spiralw.png"
theme.layout_dwindle    = "/usr/share/awesome/themes/default/layouts/dwindlew.png"
theme.layout_cornernw   = "/usr/share/awesome/themes/default/layouts/cornernww.png"
theme.layout_cornerne   = "/usr/share/awesome/themes/default/layouts/cornernew.png"
theme.layout_cornersw   = "/usr/share/awesome/themes/default/layouts/cornersww.png"
theme.layout_cornerse   = "/usr/share/awesome/themes/default/layouts/cornersew.png"

theme.snap_border_width = 2
theme.snap_bg           = "#C7A1BF"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"
theme.icon_theme   = nil

-- widgets
theme.calendar_font          = "Monospace 8"
theme.calendar_spacing       = 2
theme.calendar_week_numbers  = false
theme.calendar_start_sunday  = false
theme.calendar_long_weekdays = false

theme.widget_vol      = theme.dir .. "/icons/vol.png"
theme.widget_vol_mute = theme.dir .. "/icons/vol_mute.png"

theme.redshift_active_color     = "#66BB99"
theme.redshift_inactive_color   = "#E26B98"
theme.redshift_active_text      = "<b>R</b>"
theme.redshift_inactive_text    = "<b>R</b>"

theme.ren_tag_text_color = theme.fg_urgent
-- }}}



-- {{{ Widgets
local markup = lain.util.markup

-- spacers.
local space   = wibox.widget.textbox(" ")
local hspace1 = wibox.widget.textbox()

hspace1.forced_width = 20
--

-- textclock.
os.setlocale(os.getenv("LANG")) -- localize clock
local mytextclock = wibox.widget.textclock(
  markup("#ffffff", "<b>%a %d %b</b> ")
    .. markup("#F9B561", markup.font("FontAwesome", ""))
    .. markup("#ffffff", " <b>%H:%M</b>"),
  60,
  "Europe/Paris"
)
mytextclock.font = theme.font

--local mycalendar = wibox.widget {
    --date          = os.date("*t"),
    --font          = theme.calendar_font,
    --spacing       = theme.calendar_spacing,
    --week_numbers  = theme.calendar_week_numbers,
    --start_sunday  = theme.calendar_start_sunday,
    --long_weekdays = theme.calendar_long_weekdays,
    --widget        = wibox.widget.calendar.month
--}
--calendar:attach(mytextclock, "tr")

-- lain.widget.calendar({
-- attach_to = { mytextclock },
-- notification_preset = {
--   font = "Roboto Mono 10",
--   fg   = "#ffffff",
--   bg   = theme.bg_normal
-- }
-- })
--

-- Awesome icon.
local myawesomeicon = wibox.widget.imagebox(theme.awesome_icon, true)
--

-- volume indicator
local myvolumeicon = wibox.widget.imagebox(theme.widget_vol)
theme.myvolume = lain.widget.alsa({
  settings = function()
    if volume_now.status == "off" then
      myvolumeicon:set_image(theme.widget_vol_mute)
    else
      myvolumeicon:set_image(theme.widget_vol)
    end
    widget:set_markup(markup.font(theme.font, volume_now.level .. "% "))
  end
})
--

-- redshift indicator
local myredshift_ind = wibox.widget{
  checked            = false,
  -- transparent background
  check_color        = theme.bg_normal,
  border_color       = theme.bg_normal,
  check_border_color = theme.redshift_active_color,
  check_border_width = 2,
  color              = theme.redshift_inactive_color,
  border_width       = 0,
  shape              = gears.shape.circle,
  widget             = wibox.widget.checkbox
}

local myredshift_text = wibox.widget{
  align	 = "center",
  widget = wibox.widget.textbox,
}

local myredshift = wibox.widget{
  myredshift_ind,
  myredshift_text,
  layout = wibox.layout.stack
}

lain.widget.contrib.redshift:attach(
  myredshift_ind,
  function (active)
    if active then
	  myredshift_text:set_markup(markup(theme.redshift_active_color, theme.redshift_active_text))
	else
	  myredshift_text:set_markup(markup(theme.redshift_inactive_color, theme.redshift_inactive_text))
	end
    myredshift_ind.checked = active
  end
)
--
-- }}}



-- {{{ Make this for each connected screen
function theme.at_screen_connect(s)
  -- If wallpaper is a function, call it with the screen
  local wallpaper = theme.wallpaper
  if type(wallpaper) == "function" then
    wallpaper = wallpaper(s)
  end
  gears.wallpaper.maximized(wallpaper, s, true)

  -- Tags
  -- awful.tag(awful.util.tagnames, s, { awful.layout.layouts[1], awful.layout.layouts[1],
  --                                     awful.layout.layouts[1], awful.layout.layouts[1],
  --                                     awful.layout.layouts[1] })

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(my_table.join(
                          awful.button({ }, 1, function () awful.layout.inc( 1) end),
                          awful.button({ }, 3, function () awful.layout.inc(-1) end),
                          awful.button({ }, 4, function () awful.layout.inc( 1) end),
                          awful.button({ }, 5, function () awful.layout.inc(-1) end)
                       ))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  -- Create the wiboxes
  local wiboxlayout = wibox.layout.align.horizontal()
  wiboxlayout.expand = "none"
  s.mytopwibox = awful.wibar({ position = "top", screen = s })
                               --[[ DEBUG PURPOSE
                               ,border_width = 1, border_color = "#ffff00"
                             })
                               --]]
  s.mybottomwibox = awful.wibar({ position = "bottom", screen = s })

  -- Widgets definitions
  local top_left_widgets = wibox.widget { -- Top left widgets
    layout = wibox.layout.fixed.horizontal,
    hspace1,
    s.mytaglist,
    hspace1,
    s.mypromptbox,
  }
  local top_middle_widgets = wibox.widget { -- Top middle widget
    layout = wibox.layout.fixed.horizontal,
    hspace1,
    mytextclock,
  }
  local top_right_widgets = wibox.widget { -- Top right widgets
    layout = wibox.layout.fixed.horizontal,
    hspace1,
    wibox.widget.systray(),
    hspace1,
    myredshift,
    hspace1,
    myvolumeicon,
    theme.myvolume,
    hspace1,
  }
  local bottom_left_widgets = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    s.mylayoutbox,
    space,
  }
  local bottom_middle_widgets = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    s.mytasklist,
  }
  local bottom_right_widgets = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
  }

  -- Add widgets to the top wibox
  s.mytopwibox:setup {
    layout = wiboxlayout,
    {
      top_left_widgets,
      --[[ DEBUG PURPOSE
	  margins = 2,
	  color = "#0000ff",
      --]]
	  widget = wibox.container.margin,
    },
    {
      top_middle_widgets,
      --[[ DEBUG PURPOSE
      margins = 2,
      color = "#ff0000",
      --]]
      widget = wibox.container.margin,
    },
    {
      top_right_widgets,
      --[[ DEBUG PURPOSE
      margins = 2,
      color = "#00ff00",
      --]]
      widget = wibox.container.margin,
    },
  }

  -- Add widgets to the bottom wibox
  s.mybottomwibox:setup {
    layout = wibox.layout.align.horizontal,
    {
      bottom_left_widgets,
      widget = wibox.container.margin,
    },
    {
      bottom_middle_widgets,
      widget = wibox.container.margin,
    },
    {
      bottom_right_widgets,
      widget = wibox.container.margin,
    },
  }
end
-- }}}



return theme

-- vim: filetype=lua:expandtab:shiftwidth=2:tabstop=4:softtabstop=2:textwidth=80
