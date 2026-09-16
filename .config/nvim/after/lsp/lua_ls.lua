---@type vim.lsp.Config
return {
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
				-- nvim runtime types, replaces lazydev.nvim
				library = { vim.env.VIMRUNTIME },
			},
			completion = {
				workspaceWord = true,
				callSnippet = "Both",
			},
			hint = {
				enable = true,
				setType = false,
				paramType = true,
				paramName = "Disable",
				semicolon = "Disable",
				arrayIndex = "Disable",
			},
			doc = {
				privateName = { "^_" },
			},
			type = {
				castNumberToInteger = true,
			},
			diagnostics = {
				disable = { "incomplete-signature-doc", "trailing-space", "no-unknown" },
				groupSeverity = {
					strong = "Warning",
					strict = "Warning",
				},
				groupFileStatus = {
					["ambiguity"] = "Opened",
					["await"] = "Opened",
					["codestyle"] = "None",
					["duplicate"] = "Opened",
					["global"] = "Opened",
					["luadoc"] = "Opened",
					["redefined"] = "Opened",
					["strict"] = "Opened",
					["strong"] = "Opened",
					["type-check"] = "Opened",
					["unbalanced"] = "Opened",
					["unused"] = "Opened",
				},
				unusedLocalExclude = { "_*" },
			},
			format = {
				enable = false,
			},
		},
	},
}
