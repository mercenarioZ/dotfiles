local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	{ src = gh("folke/tokyonight.nvim") },
})

vim.cmd.colorscheme("tokyonight")
