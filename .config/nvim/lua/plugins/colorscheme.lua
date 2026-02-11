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
}
