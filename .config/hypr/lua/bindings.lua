local mod = "SUPER"

local function bind(keys, dispatcher, description, flags)
    flags = flags or {}
    flags.description = description
    hl.bind(keys, dispatcher, flags)
end

-- Applications and shell surfaces.
bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"), "Open terminal")
bind(mod .. " + E", hl.dsp.exec_cmd("thunar"), "Open files")
bind(mod .. " + B", hl.dsp.exec_cmd("xdg-open https://"), "Open browser")
bind(mod .. " + D", hl.dsp.global("quickshell:launcher"), "Open launcher")
bind(mod .. " + Space", hl.dsp.global("quickshell:launcher"), "Open launcher")
bind(mod .. " + O", hl.dsp.global("quickshell:drawer"), "Open control drawer")
bind(mod .. " + Escape", hl.dsp.global("quickshell:session"), "Open session menu")
bind("CTRL + ALT + L", hl.dsp.exec_cmd("hyprlock"), "Lock session")
bind("CTRL + ALT + Delete", hl.dsp.global("quickshell:session"), "Open session menu")

-- Window lifecycle and layout.
bind(mod .. " + Q", hl.dsp.window.close(), "Close window")
bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }), "Toggle floating")
bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), "Toggle maximize")
bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), "Toggle fullscreen")
bind(mod .. " + P", hl.dsp.window.pseudo({ action = "toggle" }), "Toggle pseudotile")
bind(mod .. " + J", hl.dsp.layout("togglesplit"), "Toggle split direction")
bind(mod .. " + G", hl.dsp.group.toggle(), "Toggle window group")
bind(mod .. " + Tab", hl.dsp.window.cycle_next({ next = true }), "Focus next window")
bind(mod .. " + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }), "Focus previous window")

for _, direction in ipairs({ "left", "right", "up", "down" }) do
    bind(mod .. " + " .. direction, hl.dsp.focus({ direction = direction }), "Focus " .. direction)
    bind(mod .. " + CTRL + " .. direction, hl.dsp.window.move({ direction = direction }), "Move window " .. direction)
    bind(mod .. " + ALT + " .. direction, hl.dsp.window.swap({ direction = direction }), "Swap window " .. direction)
end

bind(mod .. " + SHIFT + left", hl.dsp.window.resize({ x = -48, y = 0, relative = true }), "Resize window left", { repeating = true })
bind(mod .. " + SHIFT + right", hl.dsp.window.resize({ x = 48, y = 0, relative = true }), "Resize window right", { repeating = true })
bind(mod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -48, relative = true }), "Resize window up", { repeating = true })
bind(mod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 48, relative = true }), "Resize window down", { repeating = true })

bind(mod .. " + mouse:272", hl.dsp.window.drag(), "Drag window", { mouse = true })
bind(mod .. " + mouse:273", hl.dsp.window.resize(), "Resize window", { mouse = true })
bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), "Previous workspace")

-- Workspaces 1..10; the zero key maps to workspace 10.
for workspace = 1, 10 do
    local key = workspace % 10
    bind(mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }), "Workspace " .. workspace)
    bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace, follow = true }), "Move to workspace " .. workspace)
end

bind(mod .. " + U", hl.dsp.workspace.toggle_special("scratch"), "Toggle scratchpad")
bind(mod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special:scratch", follow = false }), "Move to scratchpad")

-- Media and hardware keys are handled by the shell so its OSD stays in sync.
bind("XF86AudioRaiseVolume", hl.dsp.global("quickshell:volumeUp"), "Volume up", { locked = true, repeating = true })
bind("XF86AudioLowerVolume", hl.dsp.global("quickshell:volumeDown"), "Volume down", { locked = true, repeating = true })
bind("XF86AudioMute", hl.dsp.global("quickshell:volumeMute"), "Toggle mute", { locked = true })
bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), "Toggle microphone", { locked = true })
bind("XF86MonBrightnessUp", hl.dsp.global("quickshell:brightnessUp"), "Brightness up", { locked = true, repeating = true })
bind("XF86MonBrightnessDown", hl.dsp.global("quickshell:brightnessDown"), "Brightness down", { locked = true, repeating = true })
bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), "Play or pause", { locked = true })
bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), "Play or pause", { locked = true })
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), "Next track", { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), "Previous track", { locked = true })

local screenshot_dir = "$HOME/Pictures/Screenshots"
bind("Print", hl.dsp.exec_cmd("mkdir -p " .. screenshot_dir .. "; grim " .. screenshot_dir .. "/$(date +%Y-%m-%d_%H-%M-%S).png"), "Screenshot")
bind("SHIFT + Print", hl.dsp.exec_cmd("mkdir -p " .. screenshot_dir .. "; grim -g \"$(slurp)\" " .. screenshot_dir .. "/$(date +%Y-%m-%d_%H-%M-%S).png"), "Screenshot region")
bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("mkdir -p " .. screenshot_dir .. "; grim -g \"$(slurp)\" - | swappy -f -"), "Annotate screenshot")
