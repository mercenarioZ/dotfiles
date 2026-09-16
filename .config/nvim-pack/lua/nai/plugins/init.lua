local function gh(repo)
	return "https://github.com/" .. repo
end

-- must exist before vim.pack.add, or the first install is missed
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("nai_pack_hooks", { clear = true }),
	callback = function(event)
		local name, kind = event.data.spec.name, event.data.kind
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			if not event.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	{ src = gh("folke/tokyonight.nvim") },
	{ src = gh("folke/snacks.nvim") },
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("neovim/nvim-lspconfig") },
	{ src = gh("rafamadriz/friendly-snippets") },
	-- release tags ship a prebuilt fuzzy matcher, main needs cargo
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("^1") },
	{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
	{ src = gh("windwp/nvim-ts-autotag") },
	{ src = gh("stevearc/conform.nvim") },
	{ src = gh("mfussenegger/nvim-lint") },
})

vim.cmd.colorscheme("tokyonight")

require("nai.plugins.snacks")
require("nai.plugins.lsp")
require("nai.plugins.blink")
require("nai.plugins.treesitter")
require("nai.plugins.formatting")
require("nai.plugins.linting")
