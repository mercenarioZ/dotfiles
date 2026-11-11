-- file name only, no close button
local tabline_icon_hls = {}

-- icon color
local function tabline_icon_hl(icon_hl)
	local group = "NaiTabLine" .. icon_hl
	if not tabline_icon_hls[group] then
		local tab = vim.api.nvim_get_hl(0, { name = "TabLine", link = false })
		local icon = vim.api.nvim_get_hl(0, { name = icon_hl, link = false })
		vim.api.nvim_set_hl(0, group, { fg = icon.fg, bg = tab.bg })
		tabline_icon_hls[group] = true
	end
	return group
end

-- a colorscheme change clears custom groups, so build them again
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("nai_tabline", { clear = true }),
	callback = function()
		tabline_icon_hls = {}
	end,
})

function _G.nai_tabline()
	local s = ""
	for tab = 1, vim.fn.tabpagenr("$") do
		-- divider between tabs, %T closes the previous tab's click region
		if tab > 1 then
			s = s .. "%T%#NaiTabLineSep#╎"
		end
		local buf = vim.fn.tabpagebuflist(tab)[vim.fn.tabpagewinnr(tab)]
		local name = vim.fn.fnamemodify(vim.fn.bufname(buf), ":t")
		if name == "" then
			name = "[No Name]"
		end
		local modified = vim.bo[buf].modified and " [+]" or ""
		local selected = tab == vim.fn.tabpagenr()
		local hl = selected and "%#TabLineSel#" or "%#TabLine#"

		local icon = ""
		if _G.MiniIcons then
			local glyph, icon_hl = _G.MiniIcons.get("file", name)
			-- icon colors blend into the green selected tab, keep it plain there
			local icon_group = selected and "TabLineSel" or tabline_icon_hl(icon_hl)
			icon = "%#" .. icon_group .. "#" .. glyph .. " " .. hl
		end

		s = s .. hl .. "%" .. tab .. "T " .. icon .. name:gsub("%%", "%%%%") .. modified .. " "
	end
	return s .. "%#TabLineFill#%T"
end

vim.opt.tabline = "%!v:lua.nai_tabline()"
