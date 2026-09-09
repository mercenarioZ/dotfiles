local M = {}
local mini_icons = require("mini.icons")

function M.setup()
	local colors = require("catppuccin.palettes").get_palette("mocha")

	vim.api.nvim_set_hl(0, "CustomTabActive", {
		fg = colors.crust,
		bg = colors.mauve,
		bold = true,
	})

	vim.api.nvim_set_hl(0, "CustomTabInactive", {
		fg = colors.text,
		bg = colors.surface0,
	})

	vim.api.nvim_set_hl(0, "CustomTabEdgeActive", {
		fg = colors.mauve, -- should be the same as the custom tab bg color
		bg = "NONE",
	})

	vim.api.nvim_set_hl(0, "CustomTabEdgeInactive", {
		fg = colors.surface0,
		bg = "NONE",
	})

	vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
end

function M.render()
	local parts = {}
	local current = vim.api.nvim_get_current_tabpage()

	for index, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local win = vim.api.nvim_tabpage_get_win(tab)
		local buf = vim.api.nvim_win_get_buf(win)
		local name = vim.api.nvim_buf_get_name(buf)

		local filename = vim.fn.fnamemodify(name, ":t")

		if vim.bo[buf].buftype == "terminal" then
			filename = "[Terminal]"
		elseif vim.bo[buf].filetype == "oil" then
			filename = "[Oil]"
		elseif filename == "" then
			filename = "[No name]"
		end

		local icon = mini_icons.get("file", filename) .. " "

		local modified = vim.bo[buf].modified and "[+] " or ""
		local title = " " .. modified .. icon .. filename .. " "

		title = title:gsub("%%", "%%%%")

		local state = tab == current and "Active" or "Inactive"

		parts[#parts + 1] = string.format(
			"%%%dT%%#CustomTabEdge%s#%%#CustomTab%s#%s%%#CustomTabEdge%s#%%T",
			index,
			state,
			state,
			title,
			state
		)
	end

	return table.concat(parts) .. "%#TabLineFill#"
end

return M
