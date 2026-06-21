local lazypath = vim.g.local_nvim_data_dir .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  root = vim.g.local_nvim_data_dir .. "/lazy",
  lockfile = vim.g.local_nvim_config_dir .. "/lazy-lock.json",
  install = {
    colorscheme = { "tokyonight" },
  },
  checker = {
    enabled = false,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
