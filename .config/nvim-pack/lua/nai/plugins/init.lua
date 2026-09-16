local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	{ src = gh("folke/tokyonight.nvim") },
	{ src = gh("folke/snacks.nvim") },
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("neovim/nvim-lspconfig") },
	{ src = gh("rafamadriz/friendly-snippets") },
	-- release tags ship a prebuilt fuzzy matcher, main needs cargo
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("^1") },
})

vim.cmd.colorscheme("tokyonight")

require("nai.plugins.snacks")
require("nai.plugins.lsp")
require("nai.plugins.blink")
