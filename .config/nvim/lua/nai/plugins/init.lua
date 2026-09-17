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
	{ src = gh("neanias/everforest-nvim") },
	{ src = gh("nvim-mini/mini.icons") },
	{ src = gh("folke/snacks.nvim") },
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("neovim/nvim-lspconfig") },
	{ src = gh("rafamadriz/friendly-snippets") },
	-- release tags ship a prebuilt fuzzy matcher, main needs cargo
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("^1") },
	{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
	{ src = gh("windwp/nvim-ts-autotag") },
	{ src = gh("stevearc/conform.nvim") },
	{ src = gh("nvim-lualine/lualine.nvim") },
	{ src = gh("stevearc/oil.nvim") },
	{ src = gh("lewis6991/gitsigns.nvim") },
	{ src = gh("nvim-mini/mini.pairs") },
	{ src = gh("folke/todo-comments.nvim") },
	{ src = gh("b0o/incline.nvim") },
	{ src = gh("brenoprata10/nvim-highlight-colors") },
	{ src = gh("folke/which-key.nvim") },
})

-- colorscheme first, so later plugins pick up its highlights
require("nai.plugins.colorscheme")
require("nai.plugins.icons")
require("nai.plugins.snacks")
require("nai.plugins.lsp")
require("nai.plugins.blink")
require("nai.plugins.treesitter")
require("nai.plugins.formatting")
require("nai.plugins.lualine")
require("nai.plugins.oil")
require("nai.plugins.gitsigns")
require("nai.plugins.pairs")
require("nai.plugins.todo")
require("nai.plugins.incline")
require("nai.plugins.colors")
require("nai.plugins.whichkey")
