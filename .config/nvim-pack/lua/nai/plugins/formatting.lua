local conform = require("conform")

-- markdown chain shared by .md and .mdx
local markdown = { "prettier", "markdownlint-cli2", "markdown-toc" }

conform.setup({
	default_format_opts = {
		timeout_ms = 3000,
		-- no formatter for this filetype? let the lsp format instead
		lsp_format = "fallback",
	},

	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		c = { "clang_format" },
		cpp = { "clang_format" },
		markdown = markdown,
		["markdown.mdx"] = markdown,
	},

	formatters = {
		-- only run when the file has a <!-- toc --> marker
		["markdown-toc"] = {
			condition = function(_, ctx)
				for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
					if line:find("<!%-%- toc %-%->") then
						return true
					end
				end
			end,
		},
		-- only run when markdownlint actually reported something to fix
		["markdownlint-cli2"] = {
			condition = function(_, ctx)
				local diagnostics = vim.tbl_filter(function(d)
					return d.source == "markdownlint"
				end, vim.diagnostic.get(ctx.buf))
				return #diagnostics > 0
			end,
		},
		injected = { options = { ignore_errors = true } },
	},

	format_on_save = function(bufnr)
		-- buffer-local toggle wins over the global one
		local enabled = vim.b[bufnr].autoformat
		if enabled == nil then
			enabled = vim.g.autoformat
		end
		if not enabled then
			return
		end
		return {}
	end,
})

-- on by default, same as LazyVim
vim.g.autoformat = true

vim.keymap.set({ "n", "x" }, "<leader>cf", function()
	conform.format()
end, { desc = "Format" })

vim.keymap.set({ "n", "x" }, "<leader>cF", function()
	conform.format({ formatters = { "injected" } })
end, { desc = "Format injected langs" })

vim.keymap.set("n", "<leader>uf", function()
	vim.g.autoformat = not vim.g.autoformat
	vim.notify("Autoformat " .. (vim.g.autoformat and "on" or "off"))
end, { desc = "Toggle autoformat (global)" })

vim.keymap.set("n", "<leader>uF", function()
	local enabled = vim.b.autoformat
	if enabled == nil then
		enabled = vim.g.autoformat
	end
	vim.b.autoformat = not enabled
	vim.notify("Autoformat " .. (vim.b.autoformat and "on" or "off") .. " for this buffer")
end, { desc = "Toggle autoformat (buffer)" })
