local wk = require("which-key")

wk.setup({
	-- compact popup from the helix preset
	preset = "helix",
	win = {
		-- center of the screen instead of the helix bottom right
		col = 0.5,
		row = 0.5,
		-- stay centered even when the cursor is behind the popup
		no_overlap = false,
	},
	-- names for prefixes; the keys under them are listed from each keymap's desc
	spec = {
		{
			mode = { "n", "x" },
			{ "<leader>c", group = "code" },
			{ "<leader>f", group = "file/find" },
			{ "<leader>g", group = "git" },
			{ "<leader>gh", group = "hunks" },
			{ "<leader>s", group = "search" },
			{ "<leader>u", group = "ui" },
			{ "<leader>y", group = "yank" },
			{ "[", group = "prev" },
			{ "]", group = "next" },
			{ "g", group = "goto" },
			{ "z", group = "fold" },
			-- generated on the fly: one entry per open buffer
			{
				"<leader>b",
				group = "buffer",
				expand = function()
					return require("which-key.extras").expand.buf()
				end,
			},
			-- <leader>w behaves like <c-w>, so window commands show up with names
			{
				"<leader>w",
				group = "windows",
				proxy = "<c-w>",
				expand = function()
					return require("which-key.extras").expand.win()
				end,
			},
		},
	},
})

vim.keymap.set("n", "<leader>?", function()
	wk.show({ global = false })
end, { desc = "Buffer keymaps (which-key)" })

-- keeps the <c-w> popup open so several window commands can be chained
vim.keymap.set("n", "<c-w><space>", function()
	wk.show({ keys = "<c-w>", loop = true })
end, { desc = "Window hydra mode (which-key)" })
