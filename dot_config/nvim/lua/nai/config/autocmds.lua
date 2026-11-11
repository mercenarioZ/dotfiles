local function augroup(name)
	return vim.api.nvim_create_augroup("nai_" .. name, { clear = true })
end

-- highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- reload the file if it changed outside nvim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- resize splits when the terminal window is resized
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- jump to the last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].nai_last_loc then
			return
		end
		vim.b[buf].nai_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- close throwaway buffers with q
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = { "help", "qf", "man", "checkhealth", "lspinfo", "notify", "startuptime" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- create missing parent directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- 4-space indent for JVM languages
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("jvm_indent"),
	pattern = { "kotlin", "java" },
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
		vim.bo.expandtab = true
	end,
})

-- keep at most 5 listed buffers alive
local max_buffers = 5
local recent_buffers = {}

vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup("limit_buffers"),
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
