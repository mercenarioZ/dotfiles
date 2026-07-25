-- Generic, hot-plug friendly layout. Add named monitor rules above this one
-- if you later want fixed positions for an external display.
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1.0,
})

hl.workspace_rule({ workspace = "1", default = true })
