return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		priority = 2000,
		keys = function(_, keys)
			local filtered = vim.tbl_filter(function(k)
				return k[1] ~= "<leader>e"
			end, keys)

			table.insert(filtered, { "<leader>r", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" })

			return filtered
		end,
		opts = {
			sources = { "filesystem", "buffers", "git_status" },
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
			},

			-- Unhide hidden files
			filesystem = {
				filtered_items = {
					visible = true,
					show_hidden_count = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				follow_current_file = {
					enabled = true,
				},
			},
		},
	},
}
