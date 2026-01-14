return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		opts = function()
			return {
				transparent = true,
				priority = 1000,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			}
		end,
	},
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	opts = {
	-- 		flavour = "mocha", -- or "latte", "frappe", "macchiato"
	-- 		transparent_background = true,
	-- 	},
	-- },
}
