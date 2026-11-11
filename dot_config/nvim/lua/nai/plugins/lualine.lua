-- which-key feeds internal key codes that %S renders as "~@ý", strip them
function _G.nai_showcmd()
	return (vim.api.nvim_eval_statusline("%S", {}).str:gsub("~@.", ""))
end

require("lualine").setup({
	options = {
		-- follow the active colorscheme
		theme = "auto",
		-- one statusline for all windows, matches laststatus = 3
		globalstatus = true,
		disabled_filetypes = { statusline = { "snacks_dashboard" } },
	},
	sections = {
		-- this is what shows NORMAL / INSERT / VISUAL, since showmode is off
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			"diagnostics",
			-- path relative to cwd instead of just the file name
			{ "filename", path = 1 },
		},

		lualine_x = {
			"%{reg_recording() != '' ? 'recording @' . reg_recording() : ''}",
			"%{v:lua.nai_showcmd()}", -- they are Vimscript btw
			{
				"diff",
				-- reuse gitsigns' counts, no git diff again
				source = function()
					local status = vim.b.gitsigns_status_dict
					if status then
						return {
							added = status.added,
							modified = status.changed,
							removed = status.removed,
						}
					end
				end,
			},
		},
		lualine_y = {
			{ "progress", separator = " ", padding = { left = 1, right = 0 } },
			{ "location", padding = { left = 0, right = 1 } },
		},
		lualine_z = {
			function()
				-- clock icon as an escape, raw nerd font glyphs get mangled
				return "\u{f017} " .. os.date("%R")
			end,
		},
	},
})
