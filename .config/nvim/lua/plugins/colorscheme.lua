return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		opts = function()
			return {
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			}
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha", -- or "latte", "frappe", "macchiato"
			transparent_background = true,
		},
	},
}
