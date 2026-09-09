return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
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
			is_always_hidden = function(name)
				return name == ".git" or name == ".jj"
			end,
		},
	},
	lazy = false,
	keys = {
		{
			"<leader>e",
			function()
				require("oil").open_float(LazyVim.root(), { preview = {} })
			end,
			desc = "Explorer Oil (root dir)",
		},
		{
			"<leader>E",
			function()
				require("oil").open_float(vim.fn.getcwd(), { preview = {} })
			end,
			desc = "Explorer Oil (cwd)",
		},
		{ "<leader>fe", "<leader>e", desc = "Explorer Oil (root dir)", remap = true },
		{ "<leader>fE", "<leader>E", desc = "Explorer Oil (cwd)", remap = true },
		{ "-", "<cmd>Oil --float --preview<cr>", desc = "Open parent directory" },
	},
}
