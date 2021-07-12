-- init.vim file by luc
vim.cmd "runtime init.d/options.vim"
vim.cmd "runtime init.d/autocmds.vim"

require "plugins"
require "maps"
require "commands"
require "colors"

-- Arch linux compatibility: makes it possible to load plugins installed via
-- pacman
vim.opt.runtimepath:append{"/usr/share/vim/vimfiles"}
