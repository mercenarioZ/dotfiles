require("noice").setup({
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
	},

	notify = { enabled = false },
	views = {
		cmdline_popup = {
			position = {
				row = "30%",
				col = "50%",
			},
		},
	},
})
