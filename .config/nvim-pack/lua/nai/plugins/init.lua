local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	{ src = gh("folke/tokyonight.nvim") },
	{ src = gh("folke/snacks.nvim") },
})

vim.cmd.colorscheme("tokyonight")

require("nai.plugins.snacks")
