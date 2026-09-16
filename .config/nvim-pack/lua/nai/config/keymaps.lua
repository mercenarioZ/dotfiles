local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')
keymap.set("i", "jk", "<Esc>", opts)

-- tabs
keymap.set("n", "te", ":tabedit<CR>", opts)
keymap.set("n", "<tab>", ":tabnext<CR>", opts)
keymap.set("n", "<leader>q", ":bdelete<CR>", opts)

-- move to first non-whitespace / end of line
keymap.set("n", "<leader>h", "_")
keymap.set("n", "<leader>l", "$")

-- diagnostics
keymap.set("n", "<C-m>", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, opts)

keymap.set("n", "<leader>yc", function()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })

	local messages = {}
	for _, diagnostic in ipairs(diagnostics) do
		table.insert(messages, diagnostic.message)
	end

	vim.fn.setreg("+", table.concat(messages, "\n"))
	vim.notify(#messages > 0 and "Diagnostic copied" or "No diagnostic on current line")
end, opts)

-- vertical split resize
keymap.set("n", "<leader>+", ":vertical resize +5<CR>", opts)
keymap.set("n", "<leader>-", ":vertical resize -5<CR>", opts)

-- clear search highlight
keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

-- window navigation (LazyVim gave you these for free; now they are yours)
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- move lines up/down
keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- keep cursor centered when jumping
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- indent without losing selection
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- save
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
