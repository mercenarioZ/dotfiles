local oil = require("oil")

oil.setup({
	-- open oil instead of netrw for `nvim .` and :e on a directory
	default_file_explorer = true,
	columns = { "icon", "permissions", "size", "mtime" },
	win_options = {
		number = true,
		relativenumber = true,
		cursorline = true,
	},
	float = {
		padding = 2,
		max_width = 0.85,
		max_height = 0.6,
		border = "rounded",
		preview_split = "right",
	},
	view_options = {
		show_hidden = true,
		-- dotfiles stay visible, vcs internals never do
		is_always_hidden = function(name)
			return name == ".git" or name == ".jj"
		end,
	},
	keymaps = {
		["q"] = { "actions.close", mode = "n" },
	},
})

local map = vim.keymap.set

map("n", "sf", function()
	oil.open_float(nil, { preview = {} })
end, { desc = "Explorer oil (file dir)" })

map("n", "-", "<cmd>Oil --float<cr>", { desc = "Open parent directory" })
