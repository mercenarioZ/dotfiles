-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "

-- LazyVim autoformat
vim.g.autoformat = true

local opt = vim.opt

opt.linebreak = true
opt.wrap = true
vim.opt.cmdheight = 1

if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.cmdheight = 0
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
