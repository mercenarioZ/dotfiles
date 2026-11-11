require("blink.cmp").setup({
	keymap = {
		preset = "enter",
		["<C-y>"] = { "select_and_accept" },
	},

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = {
		accept = {
			auto_brackets = { enabled = true },
		},
		menu = {
			draw = {
				treesitter = { "lsp" },
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},

	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	cmdline = {
		enabled = true,
		keymap = {
			preset = "cmdline",
			["<Right>"] = false,
			["<Left>"] = false,
		},
		completion = {
			list = { selection = { preselect = false } },
			menu = {
				-- only popup for : commands, not / search
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
			ghost_text = { enabled = true },
		},
	},
})
