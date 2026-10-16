local octo = require("octo")

octo.setup({
	picker = "snacks",
	enable_builtin = true,
})

local map = vim.keymap.set

map("n", "<leader>oi", "<cmd>Octo issue list<cr>", { desc = "List GitHub issues" })
map("n", "<leader>op", "<cmd>Octo pr list<cr>", { desc = "List GitHub pull requests" })
map("n", "<leader>od", "<cmd>Octo discussion list<cr>", { desc = "List GitHub discussions" })
map("n", "<leader>on", "<cmd>Octo notification list<cr>", { desc = "List GitHub notifications" })
map("n", "<leader>os", function()
	require("octo.utils").create_base_search_command({ include_current_repo = true })
end, { desc = "Search GitHub" })
