return {
	-- {
	-- 	"craftzdog/solarized-osaka.nvim",
	-- 	lazy = true,
	-- 	opts = function()
	-- 		return {
	-- 			transparent = true,
	-- 			priority = 1000,
	-- 			styles = {
	-- 				sidebars = "transparent",
	-- 				floats = "transparent",
	-- 			},
	-- 		}
	-- 	end,
	-- },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = true,
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
