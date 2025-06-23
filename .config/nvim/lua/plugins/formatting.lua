return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = "ConformInfo",
  opts = {
    -- format_on_save = {
    --   timeout_ms = 1000,
    --   lsp_fallback = true,
    -- },
    formatters_by_ft = {
      c = { "clang_format" },
      cpp = { "clang_format" },
    },
  },
}
