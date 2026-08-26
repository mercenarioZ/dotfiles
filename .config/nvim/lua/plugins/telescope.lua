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
			"nvim-telescope/telescope-file-browser.nvim",
		},

		keys = {
			{
				"<leader>sf",
				"<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
				desc = "File Browser",
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
				extensions = {
					file_browser = {
						hidden = { file_browser = true, folder_browser = true },
						file_ignore_patterns = { "/%.git/", "/%.jj/", "%.jj$" },
					},
				},
			})

			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "file_browser")
		end,
	},
}
