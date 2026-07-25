-- Quickshell surfaces: only the transient panels receive compositor blur.
for _, namespace in ipairs({ "quiet-drawer", "quiet-launcher", "quiet-session", "quiet-wallpaper-picker" }) do
	hl.layer_rule({
		match = { namespace = namespace },
		blur = true,
		blur_popups = true,
		ignore_alpha = 0.08,
	})
end

-- Keep the menu bar translucent over the current wallpaper, like macOS chrome.
hl.layer_rule({
	match = { namespace = "quiet-rail" },
	blur = true,
	ignore_alpha = 0.6,
})

hl.layer_rule({ match = { namespace = "quiet-wallpaper" }, no_anim = true })
hl.layer_rule({ match = { namespace = "quiet-osd" }, no_anim = true })

-- Let the wallpaper breathe through Chrome without fading fullscreen video.
hl.window_rule({
	name = "quiet-chrome-opacity",
	match = { class = "^(google-chrome|com\\.google\\.Chrome)$" },
	opacity = "0.94 override 0.86 override 1.0 override",
})

-- Small utility windows should open as deliberate floating surfaces.
for _, class in ipairs({
	"^(org.pulseaudio.pavucontrol)$",
	"^(nm-connection-editor)$",
	"^(blueman-manager)$",
	"^(org.gnome.Calculator)$",
}) do
	hl.window_rule({
		match = { class = class },
		float = true,
		center = true,
		size = { 920, 620 },
	})
end

hl.window_rule({
	name = "quiet-file-dialogs",
	match = { title = ".*(Open File|Save File|Choose Files).*" },
	float = true,
	center = true,
	size = { 980, 680 },
})

hl.window_rule({
	name = "quiet-pinentry",
	match = { class = ".*(pinentry).*" },
	float = true,
	center = true,
	stay_focused = true,
})

hl.window_rule({
	name = "quiet-xwayland-drag-fix",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
