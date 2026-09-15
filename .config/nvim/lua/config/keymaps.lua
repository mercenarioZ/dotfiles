-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')

keymap.set("i", "jk", "<Esc>", opts)

-- new tab
keymap.set("n", "te", ":tabedit<CR>", opts)
keymap.set("n", "<tab>", ":tabnext<CR>", opts)
keymap.set("n", "<leader>q", ":bdelete<CR>", opts)

-- move pointer to the first non-whitespace, to the end of line
keymap.set("n", "<leader>h", "_")
keymap.set("n", "<leader>l", "$")

-- Diagnostics
keymap.set("n", "<C-m>", function()
	vim.diagnostic.jump({
		count = 1,
		float = true,
	})
end, opts)

keymap.set("n", "<leader>yc", function()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })

	local messages = vim.tbl_map(function(diagnostic)
		return diagnostic.message
	end, diagnostics)

	vim.fn.setreg("+", table.concat(messages, "\n"))
	vim.notify(#messages > 0 and "Diagnostic copied" or "No diagnostic on current line")
end, opts)

-- Vertical split resize
keymap.set("n", "<leader>+", ":vertical resize +5<CR>", opts)
keymap.set("n", "<leader>-", ":vertical resize -5<CR>", opts)
