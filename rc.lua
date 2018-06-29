-- rc.lua



-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- {{{ Required awesome libraries
-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
-- }}}

-- {{{ Path update
local config_path = awful.util.getdir("config")
package.path = config_path .. "modules/?.lua;" .. package.path
package.path = config_path .. "modules/?/init.lua;" .. package.path
-- }}}

-- {{{ Other required awesome libraries
-- Standard awesome library
local gears = require("gears")
-- Widget and layout library
local wibox = require("wibox")
local lain  = require("lain")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Menubar
local menubar = require("menubar")
-- Hotkeys
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")
-- Compatibility
local my_table = awful.util.table or gears.table
-- }}}

-- {{{ Modules
local helpers    = require("helpers")
local xdg_menu   = require("rootmenu")
-- local tyrannical = require("tyrannical")
-- }}}



-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
                   title  = "Oops, there were errors during startup!",
                   text   = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
      in_error = true

      naughty.notify({ preset = naughty.config.presets.critical,
                       title  = "Oops, an error happened!",
                       text   = tostring(err) })
      in_error = false
  end)
end
-- }}}



-- {{{ Variable definitions
-- Names of the tags (maybe redefined in the theme file).
-- awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}

-- This is used later as the default terminal and editor to run.
local terminal      = "terminology"
local editor        = os.getenv("EDITOR") or "editor"
local editor_cmd    = terminal .. " -e " .. editor
local launcher      = "rofi -switchers window,run,ssh -show run"
local filemanager   = "pcmanfm"
local screenshooter = "shutter -f"

-- Wibar
local taglist_buttons = my_table.join(
  awful.button({                           }, 1, function(t) t:view_only() end),
  awful.button({                           }, 1,
    function(t)
	  if client.focus then
	    client.focus:move_to_tag(t)
	  end
  end),
  awful.button({                           }, 3, awful.tag.viewtoggle),
  awful.button({ modkey,                   }, 3,
    function(t)
	  if client.focus then
	    client.focus:toggle_tag(t)
	  end
  end),
  awful.button({                           }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({                           }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = my_table.join(
  awful.button({                           }, 1,
    function (c)
      if c == client.focus then
	    c.minimized = true
	  else
	    -- Without this, the following
	    -- :isvisible() makes no sense
	    c.minimized = false
	    if not c:isvisible() and c.first_tag then
	      c.first_tag:view_only()
	    end
	    -- This will also un-minimize
	    -- the client, if needed
	    client.focus = c
	    c:raise()
	  end
  end),
  awful.button({                           }, 3, helpers.client_menu_toggle()),
  awful.button({                           }, 4, function () awful.client.focus.byidx(1) end),
  awful.button({                           }, 5, function () awful.client.focus.byidx(-1) end)
)

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local altkey = "Mod1"
local modkey = "Mod4"

-- Themes define colours, icons, font and wallpapers.
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/gune/theme.lua")
-- }}}



-- {{{ Autostart applications
-- helpers.run_once("urxvtd -q -f -o &")
helpers.run_once("pcmanfm -d &")
helpers.run_once("xbindkeys &")
-- helpers.run_once("nitrogen --restore")
helpers.run_once("compton -f -b &")
helpers.run_once("unclutter -notclass libreoffice -notclass Handbrake &")
helpers.run_once("nm-applet")
helpers.run_once("blueman-applet")
helpers.run_once("copyq")
helpers.run_once("seafile-applet")
helpers.run_once("dropbox start")
helpers.run_once("keepassxc &")
--helpers.run_once("steam &")
helpers.run_once("shutter --min_at_startup")
-- }}}



-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
  { "Aide", function() return false, hotkeys_popup.show_help end},
  { "Manuel", terminal .. " -e man awesome" },
  { "Éditer config", editor_cmd .. " " .. awesome.conffile },
  { "Redémarrer", awesome.restart },
  { "Quitter", function() awesome.quit() end}
}

local browsermenu = {
  {"Chromium","/usr/bin/chromium-browser","/usr/share/pixmaps/chromium-browser.png"},
  {"Firefox","/usr/bin/firefox","/usr/share/pixmaps/firefox.png"},
  {"QupZilla","/usr/bin/qupzilla","/usr/share/pixmaps/qupzilla.png"},
}

local gamemenu = {
  {"Divinity: Original Sin", "/home/jeff/Jeux/GOG Games/Divinity Original Sin Enhanced Edition/start.sh", "/home/jeff/Jeux/GOG Games/Divinity Original Sin Enhanced Edition/support/icon.png"},
  {"Extreme Tux Racer","/usr/games/etr","/usr/share/pixmaps/etr.xpm"},
  {"Keep Talking and Nobody Explodes", "/usr/share/playonlinux/playonlinux --run 'Keep Talking and Nobody Explodes' %F", "/home/jeff/.PlayOnLinux//icones/full_size/Keep Talking and Nobody Explodes"},
  {"Little Inferno", "/home/jeff/Jeux/GOG Games/Little Inferno/start.sh", "/home/jeff/Jeux/GOG Games/Little Inferno/support/icon.png"},
  {"Moon-Lander","/usr/games/moon-lander","/usr/share/pixmaps/moon-lander.xpm"},
  {"Papers Please","/home/jeff/Jeux/GOG Games/Papers Please/start.sh","/home/jeff/Jeux/GOG Games/Papers Please/support/icon.png"},
  {"Pillars of Eternity", "/home/jeff/Jeux/GOG Games/Pillars of Eternity/start.sh", "/home/jeff/Jeux/GOG Games/Pillars of Eternity/support/icon.png"},
  {"The Witcher 2", "/home/jeff/Jeux/GOG Games/The Witcher 2 Assassins Of Kings Enhanced Edition/start.sh", "/home/jeff/Jeux/GOG Games/The Witcher 2 Assassins Of Kings Enhanced Edition/support/icon.png"},
  {"Steam", "/usr/games/steam", "/usr/share/pixmaps/steam.png"},
}

local editormenu = {
  {"Atom", "/usr/bin/atom", "/usr/share/icons/Numix-Circle/48/apps/atom.svg"},
  {"Emacs", "emacs", "/usr/share/icons/Numix-Circle/48/apps/emacs.svg"},
  {"Vim", "/usr/bin/vim", "/usr/share/icons/Numix-Circle/48/apps/vim.svg"},
}

local myappmenu = {
  {"Éditeurs de texte", editormenu},
  {"Jeux", gamemenu},
  {"Navigateurs", browsermenu},
}

local myfavmenu = {
  {"Firefox","/usr/bin/firefox","/usr/share/pixmaps/firefox.png"},
  {"Terminal", terminal}
}

local mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, beautiful.awesome_icon },
                                          { "Applications", myappmenu },
                                          { "Debian", xdgmenu },
                                          { "--------------" },
                                          {"Chromium","/usr/bin/chromium-browser","/usr/share/pixmaps/chromium-browser.png"},
                                          {"Terminal", terminal} },
                                 theme = { height = 20, width = 200 }
})

local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
menubar.utils.parse_dir("/home/jeff/Bureau/")
-- }}}



-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)
-- }}}



-- -- {{{
-- tyrannical.tags = {
--   {
--     name                  = "1:mail",
--     init                  = true,
--     selected              = false,
--     exclusive	            = true,
--     screen                = 1,
--     layout                = awful.layout.suit.max,
--     no_focus_stealing_in  = true,
--     class                 = {
--       "Claws-mail",   "Astroid",   "Thunderbird"
--     }
--   },
--   {
--     name                  = "2:web",
--     init                  = true,
--     selected              = false,
--     exclusive	            = true,
--     screen                = 1,
--     layout                = awful.layout.suit.max,
--     no_focus_stealing_in  = true,
--     class                 = {
--       "Firefox"   ,   "Chromium-browser"   ,   "Google-chrome"   ,   "qutebrowser"
--     }
--   },
--   {
--     name                  = "3:files",
--     init                  = true,
--     selected              = false,
--     exclusive             = true,
--     screen                = 1,
--     layout                = awful.layout.suit.tile,
--     exec_once             = {"pcmanfm"},
--     class                 = {
--       "Pcmanfm"   ,   "Spacefm"
--     }
--   },
--   {
--     name                  = "4:term",
--     init                  = true,
--     selected              = false,
--     exclusive             = true,
--     screen                = 1,
--     layout                = awful.layout.suit.fair,
--     no_focus_stealing_out = true,
--     class                 = {
--       "terminology"   ,   "x-terminal-emulator"   ,   "Hyper"   ,   "Lxterminal"
--     }
--   },
--   {
--     name                  = "5:divers",
--     init                  = true,
--     selected              = true,
--     exclusive             = false,
--     screen                = 1,
--     layout                = awful.layout.suit.fair,
--     no_focus_stealing_out = true,
--     fallback              = true,
--     class                 = {}
--   },
--   {
--     name                  = "6:jeux",
--     init                  = true,
--     selected              = false,
--     exclusive             = true,
--     screen                = screen.count()>1 and 2 or 1,
--     layout                = awful.layout.suit.max,
--     no_focus_stealing_in  = true,
--     no_focus_stealing_out = true,
--     class                 = {
--       "steam"   ,   "Steam"
--     }
--   },
--   {
--     name                  = "calibre",
--     init                  = false,
--     selected              = false,
--     exclusive             = true,
--     screen                = 1,
--     layout                = awful.layout.suit.max,
--     no_focus_stealing_in  = true,
--     no_focus_stealing_out = true,
--     class                 = {
--       "calibre"   ,   "calibre-gui"
--     }
--   },
--   {
--     name                  = "dev",
--     init                  = false,
--     selected              = false,
--     exclusive             = true,
--     screen                = 1,
--     layout                = awful.layout.suit.max,
--     no_focus_stealing_in  = true,
--     no_focus_stealing_out = true,
--     class                 = {
--       "atom"   ,   "Atom"   ,   "emacs"   ,   "Emacs"
--     }
--   },
--   {
--     name                  = "office",
--     init                  = false,
--     selected              = false,
--     exclusive             = true,
--     screen                = 1,
--     layout                = awful.layout.suit.fair,
--     no_focus_stealing_in  = true,
--     no_focus_stealing_out = true,
--     class                 = {
--       "libreoffice"               ,   "libreoffice-writer"   ,   "libreoffice-calc",
--       "libreoffice-startcenter"   ,   "Iscan"
--     }
--   },
--   {
--     name       	          = "keepassxc",
--     init                  = false,
--     selected              = false,
--     exclusive             = true,
--     hide                  = false,
--     screen                = 1,
--     layout                = awful.layout.suit.floating,
--     no_focus_stealing_in  = false,
--     no_focus_stealing_out = false,
--     locked                = true,
--     class                 = {
--       "keepassxc"
--     }
--   },
--   {
--     name                  = "video",
--     init                  = false,
--     selected              = false,
--     exclusive             = true,
--     screen                = 1,
--     layout                = awful.layout.suit.fair,
--     no_focus_stealing_in  = true,
--     no_focus_stealing_out = true,
--     class                 = {
--       "makemkv"   ,   "mkvtoolnix-gui"   ,   "Handbrake"
--     }
--   }
-- }
--
-- -- Ignore the tag "exclusive" property for the following clients (matched by classes)
-- tyrannical.properties.intrusive = {
--   "MPlayer"   ,   "pinentry"   ,   "feh"     ,   "alsamixer"   ,   "Calc"     ,
--   "xcalc"     ,   "gpick"      ,   "copyq"   ,   "gksudo"      ,   "keepassxc",
--   "Evince"
-- }
--
-- -- Ignore the tiled layout for the matching clients
-- tyrannical.properties.floating = {
--   "MPlayer"   ,   "pinentry"   ,   "feh"     ,   "alsamixer"   ,   "Calc"     ,
--   "xcalc"     ,   "gpick"      ,   "copyq"   ,   "gksudo"      ,   "keepassxc",
--   "Evince"    ,   "libreoffice-startcenter"  ,   "calibre"     ,   "calibre-gui"
-- }
--
-- -- Make the matching clients (by classes) on top of the default layout
-- tyrannical.properties.ontop = {
--   "MPlayer"   ,   "pinentry"   ,   "feh"     ,   "alsamixer"   ,   "Calc"     ,
--   "xcalc"     ,   "gpick"      ,   "copyq"   ,   "gksudo"      ,   "keepassxc",
--   "Evince"
-- }
--
-- -- Force the matching clients (by classes) to be centered on the screen on init
-- tyrannical.properties.placement = {
--   Calc           = awful.placement.centered,
--   Gucharmap      = awful.placement.centered,
--   Evince         = awful.placement.centered,
--   libreoffice    = awful.placement.centered,
--   calibre        = awful.placement.centered,
--   keepassxc      = awful.placement.centered,
-- }
--
-- -- tyrannical.properties.titlebars_enabled = {
-- --   qutebrowser      = false,
-- -- }
--
-- tyrannical.settings.block_children_focus_stealing = true --Block popups ()
-- tyrannical.settings.group_children                = true --Force popups/dialogs to have the same tags
--                                                          --as the parent client
-- -- }}}



-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
        border_width = beautiful.border_width,
  	    border_color = beautiful.border_normal,
		    focus	       = awful.client.focus.filter,
		    raise	       = true,
		    keys	       = clientkeys,
		    buttons	     = clientbuttons,
		    screen	     = awful.screen.preferred,
		    placement	   = awful.placement.no_overlap+awful.placement.no_offscreen+awful.placement.centered,
        -- titlebars_enabled = true,
        -- floating          = true
     }
    },
    -- No titlebars for these classes
    -- { rule_any = { class = { "Firefox", "Chromium-browser", "Google-chrome", "qutebrowser",
    --                          "Claws-mail", "Astroid", "Thunderbird" }
    --              },
    --   titlebars_enabled = false
    -- },
    -- Emacs
    { rule = { class = "Emacs" },
      callback = function(c)
        c.overwrite_class = "emacs"
      end
    }
}
-- }}}



-- {{{ Key bindings
globalkeys = my_table.join(
  -- Awesome
  awful.key({ modkey,                   }, "w", function () mymainmenu:show() end,
    {description = "Afficher menu principal", group = "awesome"}
  ),
  awful.key({ modkey,                   }, "h", hotkeys_popup.show_help,
    {description="Voir aide", group="awesome"}
  ),
  awful.key({ modkey, "Control"         }, "r", awesome.restart,
    {description = "Recharger Awesome", group = "awesome"}
  ),
  awful.key({ modkey, "Control"         }, "q", awesome.quit,
    {description = "Quitter Awesome", group = "awesome"}
  ),

  -- Tags
  awful.key({ modkey, "Shift"           }, "a", function() helpers.add_tag("?", nil, true) end,
	{description = "Ajouter un tag", group = "tag"}
  ),
  awful.key({ modkey, "Shift"           }, "d", function() helpers.del_tag() end,
	{description = "Supprimer le tag courant", group = "tag"}
  ),
  awful.key({ modkey, "Shift"           }, "r", function() helpers.ren_tag() end,
	{description = "Renommer le tag courant", group = "tag"}
  ),
  awful.key({ modkey,                   }, "Left",
    function ()
      local t = awful.screen.focused().selected_tag or nil
	  local tidx = t.index
	  if tidx > 1 then
	    awful.tag.viewprev()
	  end
	end,
    {description = "Aller au tag précédent", group = "tag"}
  ),
  awful.key({ modkey,			}, "Right",
	function ()
	  local t = awful.screen.focused().selected_tag or nil
	  local tidx = t.index
	  if tidx < #awful.screen.focused().tags then
		awful.tag.viewnext()
	  end
	end,
	{description = "Aller au tag suivant", group = "tag"}
  ),
  awful.key({ modkey, "Shift"           }, "Left",
	function ()
	  -- focused client and its tag
	  local c = client.focus
	  local t = c and c.first_tag or nil
	  if c then
	    if t.index > 1 then
		  -- define the new tag of the client
		  local nt = c.screen.tags[t.index - 1]
		  c:move_to_tag(nt)
		  nt:view_only()
		end
      end
	end,
	{description = "Déplacer le client dans le tag précédent", group = "tag"}
  ),
  awful.key({ modkey, "Shift"           }, "Right",
    function ()
	  -- focused client and its tag
	  local c = client.focus
	  local t = c and c.first_tag or nil
	  if c then
	    if t.index < #awful.screen.focused().tags then
		  -- define the new tag of the client
		  local nt = c.screen.tags[t.index + 1]
		  c:move_to_tag(nt)
		  nt:view_only()
		end
	  end
	end,
	{description = "Déplacer le client dans le tag suivant", group = "tag"}
  ),

    -- Clients
  awful.key({ modkey,                   }, "Tab",
	function ()
	  awful.client.focus.byidx(1)
	end,
	{description = "Afficher client suivant", group = "client"}
  ),
  awful.key({ modkey, "Shift"           }, "Tab",
	function ()
	  awful.client.focus.byidx(-1)
	end,
	{description = "Afficher client précédent", group = "client"}
  ),
  awful.key({ modkey,                   }, "Next", function () awful.client.swap.byidx(1) end,
	{description = "Échanger avec le client suivant", group = "client"}),
  awful.key({ modkey,                   }, "Prior", function () awful.client.swap.byidx(-1) end,
	{description = "Échanger avec le client précédent", group = "client"}),
  awful.key({ modkey,  "Shift"          }, "n",
	function ()
	  local c = awful.client.restore()
	  -- Focus restored client
	  if c then
	    client.focus = c
		c:raise()
	  end
	end,
	{description = "Déminimiser", group = "client"}
  ),

  -- Screens
  awful.key({ modkey,  "Shift"          }, "Next", function () awful.screen.focus_relative( 1) end,
	{description = "Passer sur l'écran suivant", group = "screen"}
  ),
  awful.key({ modkey,  "Shift"          }, "Prior", function () awful.screen.focus_relative(-1) end,
	{description = "Passer sur l'écran précédent", group = "screen"}
  ),

  -- Layouts
  awful.key({ modkey,                   }, "Escape", function () awful.layout.inc( 1) end,
	{description = "select next", group = "layout"}
  ),
  awful.key({ modkey, "Shift"           }, "Escape", function () awful.layout.inc(-1) end,
	{description = "select previous", group = "layout"}
  ),

  -- Mediakeys
  awful.key({                           }, "XF86AudioRaiseVolume",
	function ()
	  os.execute(string.format("amixer set %s 1%%+", beautiful.myvolume.channel))
	    beautiful.myvolume.update()
	end,
	{description = "Augmenter le volume", group = "plugins"}
  ),
  awful.key({                           }, "XF86AudioLowerVolume",
	function ()
	  os.execute(string.format("amixer set %s 1%%-", beautiful.myvolume.channel))
	  beautiful.myvolume.update()
	end,
	{description = "Diminuer le volume", group = "plugins"}
  ),
  awful.key({                          }, "XF86AudioMute",
	function ()
	  os.execute(string.format("amixer set %s toggle", beautiful.myvolume.togglechannel or beautiful.myvolume.channel))
	  beautiful.myvolume.update()
	end,
	{description = "Couper le son", group = "plugins"}
  ),
  awful.key({                          }, "XF86AudioPlay",
	function ()
	  awful.spawn.with_shell("playerctl play-pause || ncmpcpp toggle")
	end,
	{description = "Lecture / Pause", group = "plugins"}
  ),
  awful.key({                          }, "XF86AudioStop",
	function ()
	  awful.spawn.with_shell("playerctl stop || ncmpcpp stop")
	end,
	{description = "Stop", group = "plugins"}
  ),
  awful.key({                          }, "XF86AudioPrev",
	function ()
	  awful.spawn.with_shell("playerctl previous || ncmcpcpp prev")
	end,
	{description = "Piste précédente", group = "plugins"}
  ),
  awful.key({                          }, "XF86AudioNext",
	function ()
	  awful.spawn.with_shell("playerctl next || ncmpcpp next")
	end,
	{description = "Piste suivante", group = "plugins"}
  ),

  -- Other programs
  awful.key({ modkey,                   }, "e", function () awful.spawn(filemanager) end,
	{description = "Gestionnaire de fichiers", group = "launcher"}
  ),
  awful.key({ modkey,                   }, "Return", function () awful.spawn(terminal) end,
	{description = "Terminal", group = "launcher"}
  ),
  awful.key({ modkey,                   }, "v", function () awful.spawn("copyq toggle") end,
	{description = "Presse papiers", group = "launcher"}
  ),
  -- Rofi
  awful.key({ modkey,                   }, "space", function () awful.spawn(launcher) end,
	{description = "Lancer une application", group = "launcher"}
  ),
  -- Screenshot
  awful.key({ modkey,                   }, "Print", function () awful.spawn(screenshooter) end,
	{description = "Faire une capture d'écran", group = "launcher"}
  ),
  -- Prompt
  awful.key({ modkey,                   }, "r",	   function () awful.screen.focused().mypromptbox:run() end,
    {description = "Exécuter", group = "launcher"}
  ),
  -- Redshift
  awful.key({ modkey, "Shift"           }, "p", function () lain.widget.contrib.redshift:toggle() end,
	{description = "(Dés)activer Redshift", group = "launcher"}
  ),
  -- Menubar
  awful.key({ modkey,                   }, "p", function() menubar.show() end,
    {description = "Jeux", group = "applications"}
  )
)

clientkeys = my_table.join(
  awful.key({ modkey,                   }, "f",
    function (c)
	  c.fullscreen = not c.fullscreen
	  c:raise()
	end,
	{description = "Basculer en plein écran", group = "client"}),
  awful.key({ "Control",                }, "q",      function (c) c:kill() end,
	{description = "close", group = "client"}),
  awful.key({ modkey, "Control"         }, "space",  awful.client.floating.toggle					  ,
	{description = "Basculer en flottant", group = "client"}),
  awful.key({ modkey, "Control"         }, "Return", function (c) c:swap(awful.client.getmaster()) end,
	{description = "move to master", group = "client"}),
  awful.key({ modkey,                   }, "o",      function (c) c:move_to_screen() end,
	{description = "Déplacer vers l'écran", group = "client"}),
  awful.key({ modkey,                   }, "t",	     function (c) c.ontop = not c.ontop end,
	{description = "Basculer par dessus", group = "client"}),
  awful.key({ modkey,                   }, "n",
	function (c)
	  -- The client currently has the input focus, so it cannot be
	  -- minimized, since minimized clients can't have the focus.
	  c.minimized = true
	end ,
	{description = "Minimiser", group = "client"}),
  awful.key({ modkey,			}, "m",
	function (c)
	  c.maximized = not c.maximized
	  c:raise()
	end ,
	{description = "Maximiser", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, #awful.screen.focused().tags do
  globalkeys = my_table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey,                   }, "#" .. i + 9,
      function ()
        local s = awful.screen.focused()
        local t = s.tags[i]
        if t then
          t:view_only()
        end
      end,
      {description = "Afficher le tag #"..i, group = "tag"}
      ),
      -- Toggle tag display.
      awful.key({ modkey, "Control"       }, "#" .. i + 9,
        function ()
          local s = awful.screen.focused()
          local t = screen.tags[i]
          if t then
            awful.tag.viewtoggle(t)
          end
        end,
        {description = "Afficher les clients du tag #" .. i, group = "tag"}
      ),
      -- Move client to tag.
      awful.key({ modkey, "Shift"         }, "#" .. i + 9,
        function ()
          local c = client.focus
          if c then
            local t = c.screen.tags[i]
            if t then
              c:move_to_tag(t)
              t:view_only()
            end
          end
        end,
        {description = "Basculer le client en cours sur le tag #"..i, group = "tag"}
      )
  )
end

-- Set keys
root.keys(globalkeys)
-- }}}



-- {{{ Mouse bindings
clientbuttons = my_table.join(
  awful.button({                           }, 1, function (c) client.focus = c; c:raise() end),
  -- move clients with modkey and pressing left mouse button
  awful.button({ modkey,                   }, 1, awful.mouse.client.move),
  -- move clients pressing mouse wheel
  awful.button({                           }, 2, awful.mouse.client.move),
  -- resize clients pressing modkey and right mouse button
  awful.button({ modkey,                   }, 3, awful.mouse.client.resize)
)

root.buttons(
  my_table.join(
    awful.button({                           }, 3, function () mymainmenu:toggle() end)
--    awful.button({ modkey }, 4, awful.tag.viewnext),
--    awful.button({ modkey }, 5, awful.tag.viewprev)
  )
)

awful.mouse.snap.client_enabled = true
awful.mouse.drag_to_tag.enabled = true
-- }}}



-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and
    not c.size_hints.user_position
    and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = my_table.join(
    awful.button({ }, 1, function()
	  client.focus = c
      c:raise()
      awful.mouse.client.move(c)
	end),
	awful.button({ }, 3, function()
	  client.focus = c
	  c:raise()
	  awful.mouse.client.resize(c)
	end)
  )

  awful.titlebar(c):setup {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
	  buttons = buttons,
	  layout  = wibox.layout.fixed.horizontal
	},
	{ -- Middle
	  { -- Title
	    align  = "center",
		widget = awful.titlebar.widget.titlewidget(c)
	  },
	  buttons = buttons,
	  layout  = wibox.layout.flex.horizontal
	},
	{ -- Right
	  awful.titlebar.widget.floatingbutton  (c),
	  awful.titlebar.widget.maximizedbutton (c),
	  awful.titlebar.widget.stickybutton    (c),
	  awful.titlebar.widget.ontopbutton     (c),
	  awful.titlebar.widget.closebutton     (c),
	  layout = wibox.layout.fixed.horizontal()
	},
	layout = wibox.layout.align.horizontal
  }
end)

-- Uncomment to enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--   if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--     and awful.client.focus.filter(c) then
--     client.focus = c
--   end
-- end)

--[[
-- When a client is focused or reaised move the mouse to its center.
-- Its like sloppy focus but here the mouse follows focus.
client.connect_signal("request::activate", function(c)
  -- we get the current client geometry and define the mouse position
  local client_geometry = c:geometry()
  local m = {}

  m.x = client_geometry.x + client_geometry.width / 2
  m.y = client_geometry.y + client_geometry.height / 2

  -- now juste move the mouse
  mouse.coords({ x = m.x, y = m.y })
end)
--]]

-- Set border color of (un)focused client depending of numbers of client in the tag.
-- Use of helper function: count_clients(tag).
client.connect_signal("focus", function(c)
  local t = awful.screen.focused().selected_tag	-- get current tag
  local n = helpers.count_clients(t)	        -- count clients in tag
  --c.opacity = 1.0                               -- set opacity to 1.0
  if n == 1 then
    c.border_color = beautiful.border_normal	-- if just 1 client no border color update
  else
    c.border_color = beautiful.border_focus
  end
end)

client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
  --c.opacity = 0.75                              -- set opacity to 0.75
end)
-- }}}
