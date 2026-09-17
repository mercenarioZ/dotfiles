require("incline").setup({
	window = {
		margin = { vertical = 0, horizontal = 1 },
	},
	-- hide the badge while the cursor is on the line it covers
	hide = { cursorline = true },

	-- colours live in colorscheme.lua (InclineNormal / InclineNormalNC),
	-- so they survive a :colorscheme reload
	render = function(props)
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if vim.bo[props.buf].modified then
			filename = "[+] " .. filename
		end

		local icon, color = require("nvim-web-devicons").get_icon_color(filename)

		return {
			{ icon, guifg = color },
			{ " " },
			{ filename },
		}
	end,
})
