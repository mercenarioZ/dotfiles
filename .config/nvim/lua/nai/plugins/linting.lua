local lint = require("lint")

-- markdown is intentionally not linted, prose there is free-form
lint.linters_by_ft = {}

-- FileType, not BufReadPost: our autocmd is defined before filetype detection,
-- so on BufReadPost the filetype is still empty and no linter matches
vim.api.nvim_create_autocmd({ "FileType", "BufWritePost", "InsertLeave" }, {
	group = vim.api.nvim_create_augroup("nai_lint", { clear = true }),
	callback = function()
		-- picks linters from linters_by_ft for the current filetype
		lint.try_lint()
	end,
})
