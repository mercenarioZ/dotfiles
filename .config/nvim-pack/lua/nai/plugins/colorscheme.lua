require("everforest").setup({
	background = "medium",
	-- 2 also clears the statusline background, not just the editor
	transparent_background_level = 2,
	-- blend floats (pickers, hover, completion docs) into the transparent background
	float_style = "blend",

	-- same picker title colours as the old catppuccin setup, on everforest's palette
	on_highlights = function(hl, palette)
		hl.SnacksTitle = { fg = palette.bg0, bg = palette.red }
		hl.SnacksPickerInputTitle = { fg = palette.bg0, bg = palette.red }
		hl.SnacksPickerPreviewTitle = { fg = palette.bg0, bg = palette.green }
		hl.SnacksPickerToggle = { fg = palette.bg0, bg = palette.red, bold = true, italic = true }
		hl.GitSignsCurrentLineBlame = { fg = palette.grey0, italic = true }
	end,
})

vim.cmd.colorscheme("everforest")
