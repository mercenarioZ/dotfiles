-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')

keymap.set("i", "jk", "<Esc>", opts)

-- new tab
keymap.set("n", "te", ":tabedit<CR>", opts)
keymap.set("n", "<Tab>", ":bnext<CR>", opts)
keymap.set("n", "<leader>q", ":bdelete<CR>", opts)

-- move pointer to the first non-whitespace, to the end of line
keymap.set("n", "<leader>h", "_")
keymap.set("n", "<leader>l", "$")

-- Diagnostics
keymap.set("n", "<C-m>", function()
  vim.diagnostic.goto_next()
end, opts)
