return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},

		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--hidden",
						"--no-ignore",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
					file_ignore_patterns = {},
				},
				pickers = {
					find_files = {
						hidden = true,
						no_ignore = true,
						no_ignore_parent = true,
					},
				},
			})

			pcall(telescope.load_extension, "fzf")
		end,
	},
}
