hl.config({
	general = {
		gaps_in = 6,
		gaps_out = {
			top = 2,
			right = 10,
			bottom = 10,
			left = 10,
		},
		border_size = 1,
		resize_on_border = true,
		extend_border_grab_area = 10,
		layout = "dwindle",
		col = {
			active_border = {
				colors = { "#4e5d66", "#566575" },
				angle = 42,
			},
			inactive_border = "#302d2a",
		},
	},

	decoration = {
		rounding = 8,
		rounding_power = 2.4,
		active_opacity = 1.0,
		inactive_opacity = 0.96,
		fullscreen_opacity = 1.0,
		dim_inactive = false,
		shadow = {
			enabled = true,
			range = 14,
			render_power = 3,
			color = "rgba(05060799)",
			color_inactive = "rgba(05060766)",
		},
		blur = {
			enabled = true,
			size = 2,
			passes = 2,
			new_optimizations = true,
			ignore_opacity = true,
			xray = false,
			special = true,
			popups = true,
		},
	},

	input = {
		kb_layout = "us",
		repeat_rate = 50,
		repeat_delay = 300,
		follow_mouse = 1,
		sensitivity = 0,
		numlock_by_default = true,
		touchpad = {
			natural_scroll = true,
			tap_to_click = true,
			disable_while_typing = true,
		},
	},

	dwindle = {
		preserve_split = true,
		smart_resizing = true,
		use_active_for_splits = true,
		default_split_ratio = 1.0,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		vrr = 0,
		mouse_move_enables_dpms = true,
		middle_click_paste = false,
		allow_session_lock_restore = true,
	},

	binds = {
		workspace_back_and_forth = true,
		allow_workspace_cycles = true,
		scroll_event_delay = 120,
	},

	cursor = {
		sync_gsettings_theme = true,
		enable_hyprcursor = true,
		hide_on_key_press = true,
		warp_on_change_workspace = 2,
	},

	xwayland = {
		enabled = true,
		force_zero_scaling = true,
	},
})

-- Tune the built-in touchpad without changing external mouse behavior.
hl.device({
	name = "dell09ce:00-06cb:76b1-touchpad",
	sensitivity = 0.25,
	scroll_factor = 0.45,
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
