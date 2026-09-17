-- leader must be set before any keymap is defined
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- line numbers & cursor
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.virtualedit = "block" -- cursor can go past EOL in visual block

-- wrapping (your preference: wrap on, but break at word boundaries)
opt.wrap = true
opt.linebreak = true
opt.breakindent = true

-- indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.shiftround = true
opt.smartindent = true

-- search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit" -- live preview of :s
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- ui
opt.termguicolors = true
opt.signcolumn = "yes"
opt.laststatus = 3 -- one global statusline
opt.cmdheight = 0
opt.showcmdloc = "statusline" -- pending keys go to %S in the statusline
opt.showmode = false
opt.ruler = false
opt.pumheight = 10
opt.pumblend = 10
opt.winborder = "rounded" -- global float borders (0.11+)
opt.list = true
opt.conceallevel = 2
opt.fillchars = {
	fold = " ",
	foldsep = " ",
	diff = "\u{2571}", -- ╱ light diagonal, for deleted diff lines
	eob = "~",
}
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- splits
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.winminwidth = 5

-- files & undo
opt.undofile = true
opt.undolevels = 10000
opt.confirm = true -- ask to save instead of failing
opt.autowrite = true
opt.updatetime = 200
opt.timeoutlen = 300

-- folding (treesitter-based, all open by default)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99

-- misc
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.formatoptions = "jcroqlnt"
opt.jumpoptions = "view"
opt.mouse = "a"
opt.smoothscroll = true
opt.wildmode = "longest:full,full"
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- markdown
vim.g.markdown_recommended_style = 0
vim.filetype.add({ extension = { mdx = "markdown.mdx" } })
vim.treesitter.language.register("markdown", "markdown.mdx")

-- tabline: file name only, no close button
local tabline_icon_hls = {}

-- use icon same as lualine's diagnostic, display next to the line numbers
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "\u{f015a}",
			[vim.diagnostic.severity.WARN] = "\u{f002a}",
			[vim.diagnostic.severity.INFO] = "\u{f02fd}",
			[vim.diagnostic.severity.HINT] = "\u{f0336}",
		},
	},
})

-- icon color on the TabLine bg, created once per icon color
local function tabline_icon_hl(icon_hl)
	local group = "NaiTabLine" .. icon_hl
	if not tabline_icon_hls[group] then
		local tab = vim.api.nvim_get_hl(0, { name = "TabLine", link = false })
		local icon = vim.api.nvim_get_hl(0, { name = icon_hl, link = false })
		vim.api.nvim_set_hl(0, group, { fg = icon.fg, bg = tab.bg })
		tabline_icon_hls[group] = true
	end
	return group
end

-- a colorscheme change clears custom groups, so build them again
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("nai_tabline", { clear = true }),
	callback = function()
		tabline_icon_hls = {}
	end,
})

function _G.nai_tabline()
	local s = ""
	for tab = 1, vim.fn.tabpagenr("$") do
		local buf = vim.fn.tabpagebuflist(tab)[vim.fn.tabpagewinnr(tab)]
		local name = vim.fn.fnamemodify(vim.fn.bufname(buf), ":t")
		if name == "" then
			name = "[No Name]"
		end
		local modified = vim.bo[buf].modified and " +" or ""
		local selected = tab == vim.fn.tabpagenr()
		local hl = selected and "%#TabLineSel#" or "%#TabLine#"

		local icon = ""
		if _G.MiniIcons then
			local glyph, icon_hl = _G.MiniIcons.get("file", name)
			-- icon colors blend into the green selected tab, keep it plain there
			local icon_group = selected and "TabLineSel" or tabline_icon_hl(icon_hl)
			icon = "%#" .. icon_group .. "#" .. glyph .. " " .. hl
		end

		s = s .. hl .. "%" .. tab .. "T " .. icon .. name:gsub("%%", "%%%%") .. modified .. " "
	end
	return s .. "%#TabLineFill#%T"
end

opt.tabline = "%!v:lua.nai_tabline()"
