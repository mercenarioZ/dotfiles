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
	eob = " ", -- hide ~ on empty lines
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
