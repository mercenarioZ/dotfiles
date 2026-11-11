---@type vim.lsp.Config
return {
	settings = {
		gopls = {
			gofumpt = true,
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			analyses = {
				nilness = true,
				unusedparams = true,
				unusedwrite = true,
			},
		},
	},
}
