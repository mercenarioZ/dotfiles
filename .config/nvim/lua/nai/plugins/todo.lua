local todo = require("todo-comments")

-- defaults cover TODO, FIX, FIXME, BUG, HACK, WARN, PERF, NOTE, TEST
todo.setup()

local map = vim.keymap.set

map("n", "]t", function()
	todo.jump_next()
end, { desc = "Next todo comment" })

map("n", "[t", function()
	todo.jump_prev()
end, { desc = "Prev todo comment" })

-- snacks has a todo_comments picker source, no telescope or trouble needed
map("n", "<leader>st", function()
	require("snacks").picker.todo_comments()
end, { desc = "Todo" })

map("n", "<leader>sT", function()
	require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "Todo/Fix/Fixme" })
