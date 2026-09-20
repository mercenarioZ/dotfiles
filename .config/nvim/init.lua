-- bytecode cache: speeds up every require()
vim.loader.enable()

require("nai.config.options")
require("nai.config.tabline")
require("nai.config.keymaps")
require("nai.config.autocmds")
require("nai.plugins")
