require("mason").setup()

vim.lsp.enable({
	"astro",
	"clangd",
	"cssls",
	"gopls",
	"html",
	"lua_ls",
	"marksman",
	"tailwindcss",
	"vtsls",
	"vue_ls",
	"yamlls",
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("nai_lsp_keymaps", { clear = true }),
	callback = function(event)
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
		end

		map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
		map("n", "gK", vim.lsp.buf.signature_help, "Signature help")
		map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
		map("n", "<leader>cl", function()
			require("snacks").picker.lsp_config()
		end, "Lsp info")
	end,
})
