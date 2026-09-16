local TS = require("nvim-treesitter")

TS.setup({
	-- reuse parsers the old config already compiled
	install_dir = vim.fs.normalize("~/.local/share/nvim/site"),
})

-- no-op for parsers that are already installed
TS.install({
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"diff",
	"gitignore",
	"go",
	"graphql",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"printf",
	"prisma",
	"python",
	"query",
	"regex",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("nai_treesitter", { clear = true }),
	callback = function(event)
		local lang = vim.treesitter.language.get_lang(event.match)
		-- skip filetypes without an installed parser
		if not lang or not vim.treesitter.language.add(lang) then
			return
		end

		vim.treesitter.start(event.buf, lang)
		vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

require("nvim-ts-autotag").setup()
