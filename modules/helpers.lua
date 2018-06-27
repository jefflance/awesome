--[[
	lib/helpers.lua

	Library of helpers functions.

	Jeff LANCE <jeff.lance@mala.fr>
	02/07/2017
--]]



local awful        = require("awful")
local lain         = require("lain")
local beautiful    = require("beautiful")



local helpers = {}



-- {{{ client_menu_toggle
--     Toggle menu.
function helpers.client_menu_toggle()
  local instance = nil

  return function ()
	if instance and instance.wibox.visible then
      instance:hide()
	  instance = nil
	else
      instance = awful.menu.clients({ theme = { width = 250 } })
	end
  end
end
-- }}}

-- {{{ count_clients
--     Count clients in the current tag.
function helpers.count_clients()
  local t = awful.screen.focused().selected_tag
  local n = 0
  for _, c in pairs(t:clients()) do
	 n = n + 1
  end
  return n
end
-- }}}

-- {{{ count_tags
--     Count tags on the current screen.
function helpers.count_tags()
  local tags = awful.screen.tags
  return #tags
end
-- }}}

-- {{{ run_once(cmd)
--     Start once the command cmd.
function helpers.run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
end
-- }}}

-- {{{ add_tag(name, layout, bool)
--     Add a new tag named "name" with the layout, if bool set to true
--     else search for a tag named "name" and move to or create it if not already.
function helpers.add_tag(name, layout, bool)
  -- set default values for parameters
  local tagname = 'Nouveau'
  if (name and type(name) == "string") then tagname = name end
  local taglayout = layout or awful.layout.suit.floating
  local force = bool or false
  local tag = awful.tag.find_by_name(awful.screen.focused(), tagname)

  if (not tag or force) then
    tag = awful.tag.add(tagname, {
            screen = awful.screen.focused(),
            layout = taglayout })
  -- else
  --   tag:view_only()
  end
  return tag
end
-- }}}

-- {{{ del_tag
--	   Delete the current selected tag.
function helpers.del_tag()
  local t = awful.screen.focused().selected_tag
  if not t then return end
  t:delete()
end
-- }}}

-- {{{ ren_tag
--	   Rename the current tag.
function helpers.ren_tag()
  awful.prompt.run {
    prompt       = "<span foreground='#C03660'><b>Nouveau nom : </b></span>",
    textbox      = awful.screen.focused().mypromptbox.widget,
    exe_callback = function(new_name)
      if not new_name or #new_name == 0 then return end

      local t = awful.screen.focused().selected_tag
      if t then
        t.name = new_name
      end
    end
  }
end
-- }}}



return helpers
