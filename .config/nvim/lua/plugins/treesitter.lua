local parser_install_dir = vim.g.local_nvim_data_dir .. "/treesitter"

vim.opt.runtimepath:prepend(parser_install_dir)

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    parser_install_dir = parser_install_dir,
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "query",
      "python",
      "markdown",
      "markdown_inline",
      "kotlin",
      "java",
      "yaml",
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
