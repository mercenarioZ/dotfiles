-- nvim 0.12 draws lsp colours itself; the plugin already requests them from the
-- lsp and draws them too, so turn the builtin off to avoid drawing twice
vim.lsp.document_color.enable(false)

require("nvim-highlight-colors").setup({
	-- paint the text background with the colour itself
	render = "background",
	enable_hex = true, -- #e67e80
	enable_short_hex = true, -- #fff
	enable_rgb = true, -- rgb(230, 126, 128)
	enable_hsl = true, -- hsl(358, 67%, 70%)
	enable_hsl_without_function = true, -- 358 67% 70%, as in css variables
	enable_ansi = true, -- \033[31m
	enable_var_usage = true, -- var(--primary) when --primary is defined in the file
	-- tailwind colours come from the tailwind lsp, which attaches in any git repo
	enable_tailwind = false,
})

vim.keymap.set("n", "<leader>uc", function()
	require("nvim-highlight-colors").toggle()
end, { desc = "Toggle colour highlights" })
