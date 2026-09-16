local gitsigns = require("gitsigns")

-- glyphs as escapes, raw nerd font chars get mangled when files are generated
local bar = "\u{258e}" -- ▎ thin left bar
local caret = "\u{f0da}" -- nerd font caret, marks deleted lines

gitsigns.setup({
	signs = {
		add = { text = bar },
		change = { text = bar },
		delete = { text = caret },
		topdelete = { text = caret },
		changedelete = { text = bar },
		untracked = { text = bar },
	},
	signs_staged = {
		add = { text = bar },
		change = { text = bar },
		delete = { text = caret },
		topdelete = { text = caret },
		changedelete = { text = bar },
	},

	-- blame of the current line as faded virtual text, after 2s idle
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 2000,
	},

	-- keymaps only exist in buffers gitsigns attached to (files inside a repo)
	on_attach = function(bufnr)
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
		end

		-- jump between hunks; in diff mode fall back to the builtin ]c / [c
		map("n", "]h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, "Next hunk")
		map("n", "[h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, "Prev hunk")
		map("n", "]H", function()
			gitsigns.nav_hunk("last")
		end, "Last hunk")
		map("n", "[H", function()
			gitsigns.nav_hunk("first")
		end, "First hunk")

		-- stage_hunk toggles, so it also unstages; undo_stage_hunk is deprecated
		map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
		map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
		map("n", "<leader>ghS", gitsigns.stage_buffer, "Stage buffer")
		map("n", "<leader>ghR", gitsigns.reset_buffer, "Reset buffer")
		map("n", "<leader>ghp", gitsigns.preview_hunk_inline, "Preview hunk inline")
		map("n", "<leader>ghb", function()
			gitsigns.blame_line({ full = true })
		end, "Blame line")
		map("n", "<leader>ghB", gitsigns.blame, "Blame buffer")
		map("n", "<leader>ghd", gitsigns.diffthis, "Diff this")
		map("n", "<leader>ghD", function()
			gitsigns.diffthis("~")
		end, "Diff this ~")

		-- text object: dih deletes the hunk, vih selects it
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
	end,
})
