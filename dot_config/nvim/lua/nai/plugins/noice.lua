require("noice").setup({
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
		lsp_doc_border = true,
	},

	-- Noice replaces vim.lsp.buf.hover(), so these settings control its hover
	-- handler (the mapping keeps options for the native fallback).
	lsp = {
		hover = {
			silent = true,
		},
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
