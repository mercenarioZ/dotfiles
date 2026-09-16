return {
	"folke/snacks.nvim",
	keys = {
		{ "<leader>e", false },
		{ "<leader>E", false },
		{ "<leader>fe", false },
		{ "<leader>fE", false },
	},
	opts = {
		explorer = {
			enabled = false,
		},
		picker = {
			formatters = {
				file = { min_width = 100 },
			},
			sources = {
				files = {
					hidden = true,
					ignored = false,
					exclude = { ".git", ".git/**", "*/.git/*", ".jj", ".jj/**", "*/.jj/*" },
				},
				grep = {
					hidden = true,
					ignored = false,
					exclude = { ".git", ".git/**", "*/.git/*", ".jj", ".jj/**", "*/.jj/*" },
				},
			},
		},
		scroll = { enabled = false },
	},
}
