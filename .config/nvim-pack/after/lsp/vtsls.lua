local typescript = {
	updateImportsOnFileMove = { enabled = "always" },
	suggest = {
		completeFunctionCalls = true,
	},
	inlayHints = {
		enumMemberValues = { enabled = true },
		functionLikeReturnTypes = { enabled = true },
		parameterNames = { enabled = "literals" },
		parameterTypes = { enabled = true },
		propertyDeclarationTypes = { enabled = true },
		variableTypes = { enabled = false },
	},
}

-- $MASON is set by mason.setup(), which runs before any server starts
local function mason_pkg(path)
	return vim.fs.joinpath(vim.env.MASON, "packages", path)
end

---@type vim.lsp.Config
return {
	-- vue_ls only handles templates and styles; vtsls types the <script> blocks
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
	settings = {
		complete_function_calls = true,
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			tsserver = {
				-- teach tsserver about .vue and .astro imports
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = mason_pkg("vue-language-server/node_modules/@vue/language-server"),
						languages = { "vue" },
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
					},
					{
						name = "@astrojs/ts-plugin",
						location = mason_pkg("astro-language-server/node_modules/@astrojs/ts-plugin"),
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
			experimental = {
				maxInlayHintLength = 30,
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
		typescript = typescript,
		javascript = typescript, -- same settings for js
	},
}
