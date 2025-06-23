return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },

    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {},
      })

      pcall(telescope.load_extension, "fzf")
    end,
  },
}
