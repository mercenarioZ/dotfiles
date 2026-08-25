return {
	"folke/snacks.nvim",
	opts = {
		explorer = {
			hidden = true,
			ignored = false,
			exclude = { ".git", ".git/**", "*/.git/*", ".jj", ".jj/**", "*/.jj/*" },
		},
		picker = {
			sources = {
				explorer = {
					hidden = true,
					ignored = false,
					layout = {
						preset = "sidebar",
						preview = false,
						layout = {
							width = 40,
							min_width = 20,
						},
					},
				},
				files = { hidden = true, ignored = true },
				grep = { hidden = true, ignored = true },
				explorer = {
					hidden = true,
					ignored = false,
					exclude = { ".git", ".git/**", "*/.git/*", ".jj", ".jj/**", "*/.jj/*" },
				},
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
