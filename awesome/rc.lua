pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("create_class")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Uh, la cagaste con algo...",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Embarradisimo!",
			text = tostring(err),
		})
		in_error = false
	end)
end

beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")

-- Capture user home directory
local home = os.getenv("HOME")
-- This is used later as the default terminal and editor to run.

local terminal = home .. "/.local/kitty.app/bin/kitty"
local editor = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile,
}
awful.spawn.with_shell(home .. "/dotfiles/start_polybar.sh")
-- Create a launcher widget and a main menu
local myawesomemenu = {
	{
		"Hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "Manual", terminal .. " -e man awesome" },
	{ "Edit config", editor_cmd .. " " .. awesome.conffile },
	{ "Restart", awesome.restart },
	{
		"Quit",
		function()
			awesome.quit()
		end,
	},
}

beautiful.menu_height = 30
beautiful.menu_width = 200
beautiful.menu_font = "Hack Nerd Font 12"
beautiful.titlebar_font = "Hack Nerd Font 12"
beautiful.font = "JetBrainsMono Nerd Font Bold 10"

beautiful.menu_fg_normal = "#ffffff"
beautiful.menu_fg_focus = "#bfe82c"
beautiful.menu_bg_normal = "#424242"
beautiful.menu_bg_focus = "#222222"

local mymainmenu = awful.menu({
	items = {
		{ "Awesome", myawesomemenu, beautiful.awesome_icon },
		{ " Terminal", terminal },
		{ " Browser", "mullvad" },
		{ " Files", "nautilus" },
		{ " Lock", "xscreensaver-command -lock" },
		{
			" Logout",
			function()
				awesome.quit()
			end,
		},
		{ " Reboot", "shutdown -r now" },
		{ " Shutdown", "shutdown now" },
	},
})

menubar.utils.terminal = terminal

local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.centered(wallpaper, s, false)
	end
end

local function is_fedora()
	local handle = io.popen("lsb_release -is")
	local result = handle:read("*a")
	handle:close()
	return result:find("Fedora") ~= nil
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Set wallpaper
	gears.wallpaper.maximized(home .. "/Pictures/actual/background.png", s, true)

	if is_fedora() then
		if s.index == 2 then
			awful.tag({ "1", "2", "3", "4", "·", "·", "·", "·", "·" }, s, awful.layout.layouts[1])
		else
			awful.tag({ "~", "~" }, s, awful.layout.layouts[1])
		end
	else
		if s.index == 1 then
			awful.tag({ "1", "2", "3", "4", "5", "·", "·", "·", "·" }, s, awful.layout.layouts[1])
		else
			awful.tag({ "~", "~" }, s, awful.layout.layouts[1])
		end
	end
	s.mypromptbox = awful.widget.prompt()
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})
	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	})
end)

root.buttons(gears.table.join(awful.button({}, 3, function()
	mymainmenu:toggle()
end)))

globalkeys = gears.table.join(
	-- Volume control
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn("amixer set Master unmute")
		awful.spawn("amixer set Master 1%+")
	end, { description = "volume up", group = "hotkeys" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn("amixer set Master unmute")
		awful.spawn("amixer set Master 1%-")
	end, { description = "volume down", group = "hotkeys" }),
	awful.key({}, "XF86AudioMute", function()
		awful.spawn("amixer set Master toggle")
	end, { description = "toggle mute", group = "hotkeys" }),

	-- Screenshot
	awful.key({}, "Print", function()
		awful.spawn("flameshot gui")
	end, { description = "screenshot", group = "hotkeys" }),

	-- help
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),
	awful.key({ modkey }, "w", function()
		mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),

	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),

	awful.key({ modkey, "Shift" }, "f", function()
		awful.spawn("firejail /usr/bin/librewolf")
	end, { description = "open librewolf", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "m", function()
		awful.spawn(home .. "/.local/bin/open_mullbad.sh")
	end, { description = "open Mullvad", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "t", function()
		awful.spawn(home .. "/.local/bin/open_tor_browser.sh")
	end, { description = "open Tor", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "b", function()
		awful.spawn("brave-browser")
	end, { description = "open brave", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "t", function()
		awful.spawn("telegram-desktop")
	end, { description = "open telegram", group = "launcher" }),
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),
	-- Menubar
	awful.key({ modkey }, "p", function()
		awful.spawn(home .. "/.config/rofi/scripts/launcher_t5")
	end, { description = "rofi", group = "launcher" })
)

local clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey, "Shift" }, "c", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),
	awful.key({ modkey }, "n", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "minimize", group = "client" }),
	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" }),
	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

local clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {

	-- Open microsoft teams for linux, evolution and slack on workspace 1
	{ rule = { class = "session" }, properties = { screen = 1, tag = "1" } },
	{ rule = { class = "telegram-desktop" }, properties = { screen = 1, tag = "1" } },
	{ rule = { class = "teams-for-linux" }, properties = { screen = 1, tag = "1" } },
	{ rule = { class = "Evolution" }, properties = { screen = 1, tag = "1" } },
	{ rule = { class = "Slack" }, properties = { screen = 1, tag = "1" } },
	-- Open firefox, mullvad browser, brave and librewolf on workspace 2
	{ rule = { class = "firefox" }, properties = { screen = 1, tag = "2" } },
	{ rule = { class = "Mullvad Browser" }, properties = { screen = 1, tag = "2" } },
	{ rule = { class = "Brave-browser" }, properties = { screen = 1, tag = "2" } },
	{ rule = { class = "librewolf" }, properties = { screen = 1, tag = "2" } },
	{ rule = { class = "Navigator" }, properties = { screen = 1, tag = "2" } },
	-- Open Kitty terminal and gnome-terminal on workspace 3
	{ rule = { class = "kitty" }, properties = { screen = 1, tag = "3" } },
	{ rule = { class = "Gnome-terminal" }, properties = { screen = 1, tag = "3" } },
	-- Open datastudio on workspace 4, identificada por nombre no por clase
	{ rule = { name = "datastudio" }, properties = { screen = 1, tag = "4" } },
	{ rule = { class = "Blender" }, properties = { screen = 1, tag = "4" } },
	-- Open Cura and Burpsuite on workspace 5
	{ rule = { class = "UltiMaker-Cura" }, properties = { screen = 1, tag = "5" } },
	{ rule = { class = "install4j-burp-StartBurp", properties = { screen = 1, tag = "5" } } },

	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = 0,
			border_color = 0,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- Prompt / Popup windows
	{ rule = {}, properties = { placement = awful.placement.centered } },

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = false } },
}

-- Center notifications
for _, preset in pairs(naughty.config.presets) do
	preset.position = "bottom_middle"
end

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c):setup({
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle
			{ -- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)

-- Custom configuration

beautiful.useless_gap = 5

-- Second screen
awful.spawn.with_shell("xrandr --output HDMI-A-0 --primary --left-of DisplayPort-0")

-- Autostart applications

awful.spawn.with_shell("xset s off")
awful.spawn.with_shell("xset -dpms")
awful.spawn.with_shell("xset s noblank")
awful.spawn.with_shell("picom --config ~/.picom -b")
awful.spawn.with_shell(home .. "/dotfiles/start_tray_apps.sh")
awful.spawn.with_shell("xscreensaver -no-splash &")
awful.spawn.with_shell("nm-applet")

-- Default volume to 10% at startup
-- awful.spawn.with_shell("amixer -D pulse sset Master 10%")

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)
