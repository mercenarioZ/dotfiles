local pairs = require("mini.pairs")

pairs.setup({
	-- also pair inside the : command line
	modes = { insert = true, command = true, terminal = false },
})

-- the skip rules below are not mini.pairs options, mini.pairs silently ignores
-- them if passed to setup()
local skip_next = [=[[%w%%%'%[%"%.%`%$]]=] -- next char that means "don't pair"
local skip_ts = { "string" } -- treesitter captures where pairing is unwanted

local open = pairs.open

pairs.open = function(pair, neigh_pattern)
	-- keep plain behaviour in the command line
	if vim.fn.getcmdline() ~= "" then
		return open(pair, neigh_pattern)
	end

	local o, c = pair:sub(1, 1), pair:sub(2, 2)
	local line = vim.api.nvim_get_current_line()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local next = line:sub(cursor[2] + 1, cursor[2] + 1)
	local before = line:sub(1, cursor[2])

	-- third backtick of a markdown fence: close the whole code block
	if o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
		return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
	end

	-- typing ( right before a word: foo| -> (foo, not ()foo
	if next ~= "" and next:match(skip_next) then
		return o
	end

	-- inside a string, quotes and brackets are usually literal text
	local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
	for _, capture in ipairs(ok and captures or {}) do
		if vim.tbl_contains(skip_ts, capture.capture) then
			return o
		end
	end

	-- line already has more closers than openers: this ( fixes it, don't add another )
	if next == c and c ~= o then
		local _, count_open = line:gsub(vim.pesc(o), "")
		local _, count_close = line:gsub(vim.pesc(c), "")
		if count_close > count_open then
			return o
		end
	end

	return open(pair, neigh_pattern)
end

vim.keymap.set("n", "<leader>up", function()
	vim.g.minipairs_disable = not vim.g.minipairs_disable
	vim.notify("Auto pairs " .. (vim.g.minipairs_disable and "off" or "on"))
end, { desc = "Toggle auto pairs" })
