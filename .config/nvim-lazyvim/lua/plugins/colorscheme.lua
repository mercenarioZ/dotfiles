return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = true,

			custom_highlights = function(colors)
				return {
					GitSignsCurrentLineBlame = {
						fg = colors.overlay0,
						italic = true,
					},
					SnacksTitle = { fg = colors.crust, bg = colors.red },
					SnacksPickerInputTitle = { fg = colors.crust, bg = colors.red },
					SnacksPickerPreviewTitle = { fg = colors.crust, bg = colors.green },
					SnacksPickerToggle = { fg = colors.mantle, bg = colors.red, bold = true, italic = true },
				}
			end,
			float = {
				transparent = true,
			},
			integrations = {
				gitsigns = true,
				treesitter = true,
				notify = true,
				noice = true,
				telescope = true,
				fzf = true,
			},
		},
	},
}
