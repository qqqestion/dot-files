return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    spec = {
      { "<leader>f", group = "find" },
      { "<leader>l", group = "lsp" },
      { "<leader>r", group = "rename" },
      { "<leader>c", group = "code" },
      { "<leader>e", desc = "Toggle file tree" },
      { "<leader>o", desc = "Toggle outline" },
      { "<leader>w", desc = "Write file" },
      { "<leader>q", desc = "Quit window" },
    },
  },
}
