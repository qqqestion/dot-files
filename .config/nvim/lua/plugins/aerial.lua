return {
  "stevearc/aerial.nvim",
  version = "3.*",
  keys = {
    { "<leader>o", "<cmd>AerialToggle!<cr>", desc = "Toggle outline" },
  },
  opts = {
    backends = { "lsp", "treesitter", "markdown" },
    layout = {
      min_width = 30,
    },
  },
}
