hl.curve("quietOut", {
    type = "bezier",
    points = { { 0.22, 1.0 }, { 0.36, 1.0 } },
})

hl.curve("quietMove", {
    type = "spring",
    mass = 1.0,
    stiffness = 280.0,
    dampening = 30.0,
})

hl.animation({ leaf = "global", enabled = true, speed = 3.0, bezier = "quietOut" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.2, bezier = "quietOut", style = "popin 92%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.8, bezier = "quietOut", style = "popin 94%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.0, spring = "quietMove" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.2, bezier = "quietOut", style = "slidefade 14%" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2.2, bezier = "quietOut", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.8, bezier = "quietOut", style = "fade" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.0, bezier = "quietOut" })
