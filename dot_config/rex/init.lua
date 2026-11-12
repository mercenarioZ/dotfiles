---@diagnostic disable: undefined-global

local p = "ctrl+t>"

rex.bind(p .. "ctrl+t", "pane.send_key", { key = "ctrl+t" })

rex.bind(p .. "r", "client.config.reload")
rex.bind("ctrl+shift+left", "client.tab.move.backward")
rex.bind("ctrl+shift+right", "client.tab.move.forward")

rex.action({
	name = "open_in_finder",
	title = "Open Pane Directory in Finder",
	run = function(ctx)
		local terminal = "com.superlogical.terminal"
		local dir = rex.block.call(terminal, "pwd", { block_id = ctx.block_id }).pwd
		rex.exec({ "open", dir })
	end,
})
rex.bind(p .. "o", "open_in_finder")

for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
	rex.bind(p .. key, "pane.focus", { direction = dir })
	rex.bind(p .. "ctrl+" .. key, "pane.focus", { direction = dir })
	rex.bind(p .. "shift+" .. key, "pane.resize", { direction = dir })
end

rex.bind(p .. "shift+\\", "pane.split", { direction = "right" }) -- |
rex.bind(p .. "-", "pane.split", { direction = "down" })
rex.bind(p .. "shift+5", "pane.split", { direction = "right" }) -- %
rex.bind(p .. "shift+'", "pane.split", { direction = "down" }) -- "
rex.bind(p .. "shift+,", "client.tab.move.backward") -- <
rex.bind(p .. "shift+.", "client.tab.move.forward") -- >

-- tmux defaults
rex.bind(p .. "c", "client.tab.new")
rex.bind(p .. "n", "client.tab.next")
rex.bind(p .. "p", "client.tab.previous")
rex.bind(p .. ",", "client.tab.rename")
rex.bind(p .. "shift+7", "client.tab.close") -- &
rex.bind(p .. "x", "pane.close")
rex.bind(p .. "z", "pane.zoom")
rex.bind(p .. "shift+1", "pane.move_to_new_tab") -- !
rex.bind(p .. "s", "session.switch")
rex.bind(p .. "shift+4", "session.rename") -- $

-- tmux counts windows from 0, Rex tabs from 1
for i = 0, 9 do
	rex.bind(p .. i, "client.tab.goto", { index = i + 1 })
end
