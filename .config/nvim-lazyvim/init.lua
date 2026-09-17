-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("config.tabline").setup()
vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.require('config.tabline').render()"

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("CustomTabline", { clear = true }),
	callback = function()
		require("config.tabline").setup()
	end,
})
