local exclude = { ".git", ".git/**", "*/.git/*", ".jj", ".jj/**", "*/.jj/*" }

require("snacks").setup({
	-- picker: replaces telescope
	picker = {
		enabled = true,
		formatters = {
			-- longer paths before the ... truncation kicks in
			file = { min_width = 100 },
		},
		sources = {
			files = { hidden = true, ignored = false, exclude = exclude },
			grep = { hidden = true, ignored = false, exclude = exclude },
		},
	},

	-- explorer stays off, oil.nvim handles files
	explorer = { enabled = false },

	bigfile = { enabled = true }, -- disable heavy features on huge files
	quickfile = { enabled = true }, -- render the file before plugins load
	indent = { enabled = true }, -- indent guides
	notifier = { enabled = true }, -- replaces nvim-notify
	statuscolumn = { enabled = true }, -- line numbers + git signs
	words = { enabled = true }, -- highlight the symbol under the cursor
	scroll = { enabled = false },
})

local Snacks = require("snacks")
local map = vim.keymap.set

-- find
-- map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
-- map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent files" })
-- map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
-- map("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })

-- search
map("n", "<leader>/", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
map("n", "<leader>sg", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", function()
	Snacks.picker.grep_word()
end, { desc = "Grep word under cursor" })
map("n", "<leader>sd", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", "<leader>sk", function()
	Snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>sh", function()
	Snacks.picker.help()
end, { desc = "Help pages" })
map("n", "<leader>sr", function()
	Snacks.picker.resume()
end, { desc = "Resume last picker" })
map("n", "<leader>sn", function()
	Snacks.picker.notifications()
end, { desc = "Notification history" })

-- lsp
map("n", "gd", function()
	Snacks.picker.lsp_definitions()
end, { desc = "Goto definition" })
map("n", "gr", function()
	Snacks.picker.lsp_references()
end, { nowait = true, desc = "References" })
map("n", "gI", function()
	Snacks.picker.lsp_implementations()
end, { desc = "Goto implementation" })
map("n", "gy", function()
	Snacks.picker.lsp_type_definitions()
end, { desc = "Goto type definition" })
map("n", "<leader>ss", function()
	Snacks.picker.lsp_symbols()
end, { desc = "Document symbols" })

-- git
map("n", "<leader>gl", function()
	Snacks.picker.git_log()
end, { desc = "Git log" })
map("n", "<leader>gs", function()
	Snacks.picker.git_status()
end, { desc = "Git status" })

-- misc
map("n", "<leader>un", function()
	Snacks.notifier.hide()
end, { desc = "Dismiss notifications" })
map("n", "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
map("n", "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Prev reference" })
