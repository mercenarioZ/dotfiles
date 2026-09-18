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
		-- incline filename badge: purple when focused, muted otherwise
		hl.InclineNormal = { fg = palette.bg0, bg = palette.purple }
		hl.InclineNormalNC = { fg = palette.grey1, bg = palette.bg1 }
		-- tabline divider: dark rule on the inactive tab background
		hl.NaiTabLineSep = { fg = palette.grey0, bg = palette.bg3 }
		-- blink's completion menu (insert and cmdline) links to Pmenu, which
		-- float_style = "blend" leaves opaque; clear its background to match floats
		hl.BlinkCmpMenu = { fg = palette.fg, bg = palette.none }
		hl.BlinkCmpMenuBorder = { fg = palette.grey1, bg = palette.none }
		-- a bg-only "none" counts as empty and blink's default link wins, so link instead
		hl.BlinkCmpScrollBarGutter = { link = "Normal" }
	end,
})

vim.cmd.colorscheme("everforest")
