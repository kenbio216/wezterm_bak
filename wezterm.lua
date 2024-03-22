local wezterm = require("wezterm")

local launch_menu = {}
local default_prog = {}
local set_environment_variables = {}

-- Shell
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(launch_menu, {
		label = "Git Bash",
		args = { "bash.exe", "-l" },
	})
	table.insert(launch_menu, {
		label = "WSL",
		args = { "wsl.exe", "--cd", "/home/" },
	})
	default_prog = { "bash.exe", "-l" }
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
	table.insert(launch_menu, {
		label = "Zsh",
		args = { "zsh", "-l" },
	})
	default_prog = { "zsh", "-l" }
end

-- Title
function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane

	local index = ""
	if #tabs > 1 then
		index = string.format("%d: ", tab.tab_index + 1)
	end

	local process = basename(pane.foreground_process_name)

	return { {
		Text = " " .. index .. process .. " ",
	} }
end)

-- Startup
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	-- window:gui_window():maximize()
end)

local config = {
	-- Basic
	check_for_updates = false,
	switch_to_last_active_tab_when_closing_tab = false,
	enable_scroll_bar = true,

	-- Window
	-- 额外添加的一部分
	window_decorations = "RESIZE",
	show_new_tab_button_in_tab_bar = false,
	initial_rows = 30,
	initial_cols = 90,

	native_macos_fullscreen_mode = true,
	adjust_window_size_when_changing_font_size = false,
	window_background_opacity = 0.9,
	window_padding = {
		left = 20,
		right = 20,
		top = 20,
		bottom = 5,
	},
	window_background_image_hsb = {
		brightness = 0.8,
		hue = 1.0,
		saturation = 1.0,
	},

	-- Font
	font = wezterm.font_with_fallback({ "JetBrains Mono" }),
	font_size = 16,
	freetype_load_target = "Mono",

	-- Tab bar
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = false,
	show_tab_index_in_tab_bar = false,
	tab_bar_at_bottom = true,
	tab_max_width = 25,

	-- Keys
	disable_default_key_bindings = false,
	leader = {
		key = "Space",
		mods = "CTRL",
	},

	-- Allow using ^ with single key press.
	use_dead_keys = false,

	keys = { -- New/close pane
		{
			key = "n",
			mods = "LEADER",
			action = wezterm.action({
				SpawnTab = "CurrentPaneDomain",
			}),
		},
		{ key = "F11", mods = "NONE", action = wezterm.action.ToggleFullScreen },
		{ key = "F12", mods = "NONE", action = wezterm.action.ShowDebugOverlay },
		{
			key = "x",
			mods = "LEADER",
			action = wezterm.action({
				CloseCurrentPane = {
					confirm = true,
				},
			}),
		},
		{
			key = "X",
			mods = "LEADER",
			action = wezterm.action({
				CloseCurrentTab = {
					confirm = true,
				},
			}),
		}, -- Pane navigation
		{
			key = "h",
			mods = "LEADER",
			action = wezterm.action({
				ActivatePaneDirection = "Left",
			}),
		},
		{
			key = "j",
			mods = "LEADER",
			action = wezterm.action({
				ActivatePaneDirection = "Down",
			}),
		},
		{
			key = "k",
			mods = "LEADER",
			action = wezterm.action({
				ActivatePaneDirection = "Up",
			}),
		},
		{
			key = "l",
			mods = "LEADER",
			action = wezterm.action({
				ActivatePaneDirection = "Right",
			}),
		}, -- Tab navigation
		{
			key = "z",
			mods = "LEADER",
			action = "TogglePaneZoomState",
		},
		{
			key = "1",
			mods = "LEADER",
			action = wezterm.action({
				ActivateTab = 0,
			}),
		},
		{
			key = "2",
			mods = "LEADER",
			action = wezterm.action({
				ActivateTab = 1,
			}),
		},
		{
			key = "3",
			mods = "LEADER",
			action = wezterm.action({
				ActivateTab = 2,
			}),
		},
		{
			key = "4",
			mods = "LEADER",
			action = wezterm.action({
				ActivateTab = 3,
			}),
		},
		{
			key = "5",
			mods = "LEADER",
			action = wezterm.action({
				ActivateTab = 4,
			}),
		},
		{
			key = "6",
			mods = "LEADER",
			action = wezterm.action({
				ActivateTab = 5,
			}),
		},
		{
			key = "7",
			mods = "LEADER",
			action = wezterm.action({
				ActivateTab = 6,
			}),
		},
		{
			key = "8",
			mods = "LEADER",
			action = wezterm.action({
				ActivateTab = 7,
			}),
		},
		{
			key = "9",
			mods = "LEADER",
			action = wezterm.action({
				ActivateTab = 8,
			}),
		},
		-- {
		-- 	key = "t",
		-- 	mods = "CTRL",
		-- 	action = wezterm.action.SpawnTab("CurrentPaneDomain"),
		-- },
		{
			key = "w",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentTab({
				confirm = true,
			}),
		},
		{
			key = "d",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentPane({
				confirm = true,
			}),
		},
		{
			key = "h",
			mods = "ALT|CTRL",
			action = wezterm.action({
				ActivateTabRelative = -1,
			}),
		},
		{
			key = "l",
			mods = "ALT|CTRL",
			action = wezterm.action({
				ActivateTabRelative = 1,
			}),
		}, -- Resize
		{
			key = "h",
			mods = "ALT|SHIFT",
			action = wezterm.action({
				AdjustPaneSize = { "Left", 5 },
			}),
		},
		{
			key = "j",
			mods = "ALT|SHIFT",
			action = wezterm.action({
				AdjustPaneSize = { "Down", 5 },
			}),
		},
		{
			key = "k",
			mods = "ALT|SHIFT",
			action = wezterm.action({
				AdjustPaneSize = { "Up", 5 },
			}),
		},
		{
			key = "l",
			mods = "ALT|SHIFT",
			action = wezterm.action({
				AdjustPaneSize = { "Right", 5 },
			}),
		}, -- Split
		{
			key = "-",
			mods = "LEADER",
			action = wezterm.action.SplitVertical({
				domain = "CurrentPaneDomain",
			}),
		},
		{
			key = "\\",
			mods = "LEADER",
			action = wezterm.action.SplitHorizontal({
				domain = "CurrentPaneDomain",
			}),
		}, -- Copy/paste buffer
		{
			key = "[",
			mods = "LEADER",
			action = "ActivateCopyMode",
		},
		{
			key = "]",
			mods = "LEADER",
			action = "QuickSelect",
		},
	},

	color_scheme = "Catppuccin Mocha",

	inactive_pane_hsb = {
		hue = 1.0,
		saturation = 1.0,
		brightness = 1.0,
	},

	mouse_bindings = { -- Paste on right-click
		{
			event = {
				Down = {
					streak = 1,
					button = "Right",
				},
			},
			mods = "NONE",
			action = wezterm.action({
				PasteFrom = "Clipboard",
			}),
		}, -- Change the default click behavior so that it only selects
		-- text and doesn't open hyperlinks
		{
			event = {
				Up = {
					streak = 1,
					button = "Left",
				},
			},
			mods = "NONE",
			action = wezterm.action({
				CompleteSelection = "PrimarySelection",
			}),
		}, -- CTRL-Click open hyperlinks
		{
			event = {
				Up = {
					streak = 1,
					button = "Left",
				},
			},
			mods = "CTRL",
			action = "OpenLinkAtMouseCursor",
		},
	},

	default_prog = default_prog,
	set_environment_variables = set_environment_variables,
	launch_menu = launch_menu,
}

return config
