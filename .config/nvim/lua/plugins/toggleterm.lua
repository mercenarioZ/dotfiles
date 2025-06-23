return {
  "akinsho/toggleterm.nvim",
  lazy = true,
  version = "*",
  cmd = { "ToggleTerm" },
  keys = {
    {
      "<leader>tf",
      function()
        local count = vim.v.count1
        require("toggleterm").toggle(count, 0, LazyVim.root.get(), "float")
      end,
      desc = "ToggleTerm (float root_dir)",
    },

    {
      "<leader>th",
      function()
        local count = vim.v.count1
        require("toggleterm").toggle(count, 13, LazyVim.root.get(), "horizontal")
      end,
      desc = "ToggleTerm (horizontal root_dir)",
    },

    {
      "<leader>t2h",
      function()
        require("toggleterm").toggle(2, 13, LazyVim.root.get(), "horizontal")
      end,
      { noremap = true, silent = true, desc = "Toggle terminal 2 (horizontal split)" },
    },

    {
      "<leader>tn",
      "<cmd>ToggleTermSetName<cr>",
      desc = "Set term name",
    },

    {
      "<leader>ts",
      "<cmd>TermSelect<cr>",
      desc = "Select term",
    },

    {
      "<leader>tt",
      function()
        require("toggleterm").toggle(1, 100, LazyVim.root.get(), "tab")
      end,
      desc = "ToggleTerm (tab root_dir)",
    },
  },
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.column * 0.4
      end
    end,

    open_mapping = [[<c-\>]],

    hide_numbers = true,
    shade_terminals = true,
    close_on_exit = true,
    start_in_insert = true,
    persist_size = true,
    direction = "float" or "horizontal" or "vertical" or "window",

    shell = "pwsh.exe",

    float_opts = {
      border = "curved",
      width = math.ceil(vim.o.columns * 0.8),
      height = math.ceil(vim.o.columns * 0.2),
    },
  },
}
