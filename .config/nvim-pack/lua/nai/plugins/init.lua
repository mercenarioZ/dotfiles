local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	{ src = gh("folke/tokyonight.nvim") },
	{ src = gh("folke/snacks.nvim") },
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("neovim/nvim-lspconfig") },
})

vim.cmd.colorscheme("tokyonight")

require("nai.plugins.snacks")
require("nai.plugins.lsp")
