return {
	"folke/snacks.nvim",
	opts = {
		explorer = { hidden = true, ignored = true },
		picker = {
			sources = {
				explorer = {
					hidden = true,
					ignored = false,
					layout = {
						preset = "sidebar",
						preview = false,
						layout = {
							width = 32,
							min_width = 20,
						},
					},
				},
				files = { hidden = true, ignored = true },
				grep = { hidden = true, ignored = true },
			},
		},
		scroll = { enabled = false },
	},
}
