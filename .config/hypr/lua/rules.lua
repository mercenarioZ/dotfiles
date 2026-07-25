-- Quickshell surfaces: only the transient panels receive compositor blur.
for _, namespace in ipairs({ "quiet-drawer", "quiet-launcher", "quiet-session", "quiet-wallpaper-picker" }) do
    hl.layer_rule({
        match = { namespace = namespace },
        blur = true,
        blur_popups = true,
        ignore_alpha = 0.08,
    })
end

hl.layer_rule({ match = { namespace = "quiet-wallpaper" }, no_anim = true })
hl.layer_rule({ match = { namespace = "quiet-osd" }, no_anim = true })

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
