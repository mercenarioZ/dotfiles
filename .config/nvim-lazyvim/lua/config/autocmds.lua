-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"kotlin",
		"java",
	},

	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
		vim.bo.expandtab = true
	end,
})

local max_buffers = 5

local recent_buffers = {}

local limit_buffers_group = vim.api.nvim_create_augroup("limit_buffers", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
	group = limit_buffers_group,

	callback = function(event)
		local current = event.buf

		if not vim.bo[current].buflisted or vim.bo[current].buftype ~= "" then
			return
		end

		recent_buffers = vim.tbl_filter(
			---@param buf integer
			function(buf)
				return vim.api.nvim_buf_is_valid(buf)
					and vim.bo[buf].buflisted
					and vim.bo[buf].buftype == ""
					and buf ~= current
			end,
			recent_buffers
		)

		table.insert(recent_buffers, current)

		while #recent_buffers > max_buffers do
			local closed = false
			for i, buf in ipairs(recent_buffers) do
				if buf ~= current and not vim.bo[buf].modified then
					vim.api.nvim_buf_delete(buf, { force = false })

					table.remove(recent_buffers, i)
					closed = true
					break
				end
			end

			if not closed then
				break
			end
		end
	end,
})
