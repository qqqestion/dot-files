local source = debug.getinfo(1, "S").source:sub(2)
local config_dir = vim.fn.fnamemodify(source, ":p:h")
local xdg_config_home = vim.fn.fnamemodify(config_dir, ":h")
local local_dir = config_dir .. "/.local"

vim.env.XDG_CONFIG_HOME = xdg_config_home
vim.env.XDG_DATA_HOME = local_dir .. "/share"
vim.env.XDG_STATE_HOME = local_dir .. "/state"
vim.env.XDG_CACHE_HOME = config_dir .. "/.cache"

vim.g.local_nvim_config_dir = config_dir
vim.g.local_nvim_data_dir = vim.env.XDG_DATA_HOME .. "/nvim"

vim.opt.runtimepath:prepend(config_dir)
vim.opt.packpath:prepend(config_dir)
package.path = table.concat({
  config_dir .. "/lua/?.lua",
  config_dir .. "/lua/?/init.lua",
  package.path,
}, ";")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
