return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "BufReadPost",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = vim.g.ai_cmp,
			keymap = {
				accept = false,
				next = "<M-]>",
				prev = "<M-[>",
			},
		},
		panel = { enabled = false },
		filetypes = {
			markdown = true,
			help = true,
		},
	},
}

